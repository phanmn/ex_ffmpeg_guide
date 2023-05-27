defmodule ExFfmpegGuide.Transcoder.Input.Rtmp do
  use Construct do
    field(:url, :string, enforce: true)
  end
end

defimpl ExFfmpegGuide.Transcoder.Input, for: ExFfmpegGuide.Transcoder.Input.Rtmp do
  # alias ExFfmpegGuide.Transcoder.Input.Rtmp

  def to_args(rtmp) do
    [
      {"f", "flv"},
      {"i", rtmp.url}
    ]
  end
end
