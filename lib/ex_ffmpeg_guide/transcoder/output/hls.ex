defmodule ExFfmpegGuide.Transcoder.Output.Hls do
  alias ExFfmpegGuide.Transcoder.Output.Hls

  use Construct do
    field(:variants, [Hls.Variant], default: [])
    field(:codec, Hls.Codec, enforce: true)
    field(:latency_level, Hls.LatencyLevel, enforce: true)
    field(:master_pl_name, :string, default: "stream.m3u8")
    field(:segment_name, :string, default: "stream-%03d.ts")
    field(:output, :string, enforce: true)

    field(:flags, [:string],
      default: ["delete_segments", "independent_segments", "program_date_time"]
    )
  end
end

defimpl ExFfmpegGuide.Transcoder.Output, for: ExFfmpegGuide.Transcoder.Output.Hls do
  alias ExFfmpegGuide.Transcoder.Output.Hls

  def to_args(hls) do
    hls
    |> Hls.ArgsBuilder.build()
  end
end
