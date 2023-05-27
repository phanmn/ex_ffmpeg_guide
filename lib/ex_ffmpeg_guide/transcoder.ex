defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide.Transcoder

  use Construct do
    field(:hls_variants, [Transcoder.HlsVariant], default: [])
    field(:codec, Transcoder.Codec, enforce: true)
    field(:latency_level, Transcoder.LatencyLevel, enforce: true)
  end
end
