defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide.Transcoder.Output

  use Construct do
    field(:outputs, [Output], default: nil)
  end
end
