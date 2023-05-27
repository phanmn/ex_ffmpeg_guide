defmodule ExFfmpegGuide.Transcoder.Output.Hls.Codec.Libx264Test do
  use ExUnit.Case
  alias ExFfmpegGuide.Transcoder.Output.Hls.Codec
  doctest Codec.Libx264

  @codec %Codec.Libx264{}

  test "extra_filters" do
    assert "" ==
             @codec
             |> Codec.extra_filters()
  end

  describe "preset_for_cpu_level" do
    test "Level 0" do
      assert "ultrafast" ==
               @codec
               |> Codec.preset_for_cpu_level(0)
    end

    test "Level 1" do
      assert "superfast" ==
               @codec
               |> Codec.preset_for_cpu_level(1)
    end
  end
end
