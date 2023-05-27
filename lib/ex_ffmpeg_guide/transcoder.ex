defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide.Transcoder

  use Construct do
    field(:hls, [Transcoder.Hls], default: nil)
  end
end
