defmodule ExFfmpegGuide.Transcoder.CommandArgsBuilder do
  alias ExFfmpegGuide.Transcoder
  alias ExFfmpegGuide.Transcoder.Codec
  alias ExFfmpegGuide.Transcoder.HlsVariant

  def build(transcoder = %Transcoder{variants: variants}) do
    variants
    |> Enum.with_index()
    |> Enum.map(fn {variant, index} ->
      %{variant | index: index}
    end)
    |> Enum.reduce({[], []}, fn variant, {flags, maps} ->
      flags = variant_flags(variant, transcoder) ++ flags
      maps = ["v:#{variant.index},a:#{variant.index}" | maps]

      {flags, maps}
    end)
    |> then(fn {flags, maps} ->
      maps = maps |> Enum.reverse() |> Enum.join(" ")

      [{"var_stream_map", maps} | flags]
      |> Enum.reverse()
    end)
  end

  defp variant_flags(variant = %HlsVariant{}, transcoder = %Transcoder{}) do
    video_quality_flags(variant, transcoder)
  end

  defp video_quality_flags(%HlsVariant{index: index, passthrough: true}, _) do
    [
      {"map", "v:0"},
      {"c:v:#{index}", "copy"}
    ]
  end

  defp video_quality_flags(
         variant = %HlsVariant{index: index},
         transcoder = %Transcoder{codec: codec}
       ) do
    gop = variant.framerate * transcoder.latency_level.seconds_per_segment

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
    |> Kernel.++(variant |> Codec.variant_flags(codec))
  end
end
