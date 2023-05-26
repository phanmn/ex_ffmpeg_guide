defmodule ExFfmpegGuide.Transcoder.Codec.Libx264 do
  use Construct do
  end
end

defimpl ExFfmpegGuide.Transcoder.Codec, for: ExFfmpegGuide.Transcoder.Codec.Libx264 do
  alias ExFfmpegGuide.Transcoder.HlsVariant
  def name(_), do: "libx264"

  def variant_flags(_codec, variant = %HlsVariant{index: index}) do
    [
      # How often the encoder checks the bitrate in order to meet average/max values
      {"x264-params:v:#{index}", "\"scenecut=0:open_gop=0\""},
      {"bufsize:v:#{index}", variant |> HlsVariant.buffer_size()},
      {"profile:v:#{index}", "high"}
    ]
  end

  @doc ~S"""
  ## Examples

    iex> %ExFfmpegGuide.Transcoder.Codec.Libx264{} |> ExFfmpegGuide.Transcoder.Codec.extra_filters()
    ""
  """
  def extra_filters(_) do
    ""
  end

  def preset_for_cpu_level(_, 0) do
    "ultrafast"
  end

  def preset_for_cpu_level(_, 1) do
    "superfast"
  end

  def preset_for_cpu_level(_, 2) do
    "veryfast"
  end

  def preset_for_cpu_level(_, 3) do
    "faster"
  end

  def preset_for_cpu_level(_, 4) do
    "fast"
  end
end
