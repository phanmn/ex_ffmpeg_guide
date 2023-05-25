defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide

  use Construct do
    field(:hls_variants, [Transcoder.HlsVariant], default: [])
    field(:codec, Transcoder.Codec)
    field(:latency_level, Transcoder.LatencyLevel)
  end

  def variant_opts(transcoder = %__MODULE{}) do
  end
end
