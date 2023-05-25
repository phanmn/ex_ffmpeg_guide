defmodule ExFfmpegGuide.Transcoder.Codec.Libx264 do
  use Construct do
  end
end

defimpl ExFfmpegGuide.Transcoder.Codec, for: ExFfmpegGuide.Transcoder.Codec.Libx264 do
  alias ExFfmpegGuide.Transcoder.Variant
  def name(_), do: "libx264"

  def variant_flags(variant = %Variant{index: index}, codec) do
    [
      # How often the encoder checks the bitrate in order to meet average/max values
      {"x264-params:v:#{index}", "\"scenecut=0:open_gop=0\""},
      {"bufsize:v:#{index}", variant |> Variant.buffer_size()},
      {"profile:v:#{index}", "high"}
    ]
  end
end
