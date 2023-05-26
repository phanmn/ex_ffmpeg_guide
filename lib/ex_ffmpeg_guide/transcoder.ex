defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide.Transcoder

  use Construct do
    field(:hls_variants, [Transcoder.HlsVariant], default: [])
    field(:codec, Transcoder.Codec)
    field(:latency_level, Transcoder.LatencyLevel)
  end
end
