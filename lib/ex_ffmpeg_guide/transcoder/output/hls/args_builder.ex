defmodule ExFfmpegGuide.Transcoder.Output.Hls.ArgsBuilder do
  alias ExFfmpegGuide.Transcoder.Output.Hls
  alias ExFfmpegGuide.Transcoder.Output.Hls.Codec
  alias ExFfmpegGuide.Transcoder.Output.Hls.Variant

  def build(hls = %Hls{variants: variants, codec: codec}) do
    variants
    |> Enum.with_index()
    |> Enum.map(fn {variant, index} ->
      %{variant | index: index}
    end)
    |> Enum.reduce({[], []}, fn variant, {flags, maps} ->
      flags = variant_flags(variant, hls) ++ flags
      maps = ["v:#{variant.index},a:#{variant.index},name:#{variant.name}" | maps]

      {flags, maps}
    end)
    |> then(fn {flags, maps} ->
      maps = maps |> Enum.reverse() |> Enum.join(" ")

      flags
      |> Kernel.++([
        {"var_stream_map", "\"#{maps}\""}
      ])
      |> Kernel.++([
        {"f", "hls"},
        {"hls_time", hls.latency_level.seconds_per_segment},
        {"hls_list_size", hls.latency_level.segment_count},
        {"hls_delete_threshold", hls.latency_level.segment_count * 2},
        {"hls_flags", hls.flags |> Enum.join("+")},
        {"hls_segment_filename", hls.segment_name},
        {"segment_format_options", "mpegts_flags=mpegts_copyts=1"}
      ])
      |> Kernel.++(codec |> Codec.extra_arguments())
      |> Kernel.++([
        {"pix_fmt", codec |> Codec.pixel_format()},
        {"sc_threshold", 0},
        {"master_pl_name", hls.master_pl_name},
        {"y", hls.output}
      ])
    end)
  end

  defp variant_flags(
         variant = %Variant{},
         hls = %Hls{codec: codec}
       ) do
    video_quality_flags(variant, hls)
    |> Kernel.++(audio_quality_flags(variant, hls))
    |> Kernel.++(video_filter_flags(variant, hls))
    |> Kernel.++([
      {"preset", codec |> Codec.preset_for_cpu_level(variant.cpu_usage_level)}
    ])
  end

  defp audio_quality_flags(%Variant{index: index, audio_passthrough: true}, _) do
    [
      {"map", "a:0?"},
      {"c:a:#{index}", "copy"}
    ]
  end

  defp audio_quality_flags(variant = %Variant{index: index}, _) do
    # libfdk_aac is not a part of every ffmpeg install, so use "aac" instead
    encoder_codec = "aac"

    [
      {"map", "a:0?"},
      {"c:a:#{index}", encoder_codec},
      {"b:a:#{index}", variant.audio_bitrate}
    ]
  end

  defp video_quality_flags(%Variant{index: index, video_passthrough: true}, _) do
    [
      {"map", "v:0"},
      {"c:v:#{index}", "copy"}
    ]
  end

  defp video_quality_flags(
         variant = %Variant{index: index},
         hls = %Hls{codec: codec}
       ) do
    gop = variant.framerate * hls.latency_level.seconds_per_segment

    [
      {"map", "v:0"},
      # Video codec used for this variant
      {"c:v:#{index}", codec |> Codec.name()},
      # The average bitrate for this variant allowing space for audio
      {"b:v:#{index}", "#{variant |> Variant.allocated_video_bitrate()}k"},
      # The max bitrate allowed for this variant
      {"maxrate:v:#{index}", "#{variant |> Variant.max_video_bitrate()}k"},
      # Suggested interval where i-frames are encoded into the segments
      {"g:v:#{index}", gop},
      # minimum i-keyframe interval
      {"keyint_min:v:#{index}", gop},
      {"r:v:#{index}", "#{variant.framerate}"}
    ]
    |> Kernel.++(codec |> Codec.variant_flags(variant))
  end

  defp video_filter_flags(
         %Variant{
           index: index,
           video_size: %{width: video_width, height: video_height},
           video_passthrough: video_passthrough
         },
         %Hls{codec: codec}
       )
       when video_passthrough == true or (video_width == 0 and video_height == 0) do
    codec
    |> Codec.extra_filters()
    |> case do
      "" ->
        []

      filters ->
        [
          {"filter:v:#{index}", filters}
        ]
    end
  end

  defp video_filter_flags(%Variant{index: index, video_size: video_size}, %Hls{
         codec: codec
       }) do
    filters =
      [
        "scale=#{video_size |> video_size_string()}",
        codec |> Codec.extra_filters()
      ]
      |> Enum.filter(fn filter -> filter != "" and filter != nil end)

    [
      # Scaling Algorithm
      {"sws_flags", "bilinear"},
      {"filter:v:#{index}", filters |> Enum.join(",")}
    ]
  end

  defp video_size_string(%{width: width, height: height}) do
    cond do
      width != 0 and height != 0 -> "#{width}:#{height}"
      width != 0 -> "#{width}:-2"
      height != 0 -> "-2:#{height}"
      true -> ""
    end
  end
end
