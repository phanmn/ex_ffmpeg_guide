defmodule ExFfmpegGuide.Transcoder do
  alias ExFfmpegGuide.Transcoder.Output
  alias ExFfmpegGuide.Transcoder.Input

  use Construct do
    field(:outputs, [Output], enforce: true)
    field(:input, Input, enforce: true)
  end

  def to_args(%__MODULE__{input: input, outputs: outputs}) do
    input
    |> Input.to_args()
    |> Kernel.++(
      outputs
      |> Enum.map(&Output.to_args/1)
    )
    |> List.flatten()
  end
end
