defmodule ExFfmpegGuide.Transcoder.Input.Url do
  use Construct do
    field(:url, :string, enforce: true)
  end
end

defimpl ExFfmpegGuide.Transcoder.Input, for: ExFfmpegGuide.Transcoder.Input.Url do
  # alias ExFfmpegGuide.Transcoder.Input.Rtmp

  def to_args(url) do
    [
      {"i", url.url}
    ]
  end
end
