defmodule ExFfmpegGuide.Transcoder.Hls do
  alias ExFfmpegGuide.Transcoder.Hls

  use Construct do
    field(:variants, [Hls.Variant], default: [])
    field(:codec, Hls.Codec, enforce: true)
    field(:latency_level, Hls.LatencyLevel, enforce: true)
  end
end
