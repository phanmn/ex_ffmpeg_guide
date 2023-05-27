defmodule ExFfmpegGuide.Transcoder.Codec.Libx264Test do
  use ExUnit.Case
  doctest ExFfmpegGuide.Transcoder.Codec.Libx264

  @codec %ExFfmpegGuide.Transcoder.Codec.Libx264{}

  test "extra_filters" do
    assert "" ==
             @codec
             |> ExFfmpegGuide.Transcoder.Codec.extra_filters()
  end

  describe "preset_for_cpu_level" do
    test "Level 0" do
      assert "ultrafast" ==
               @codec
               |> ExFfmpegGuide.Transcoder.Codec.preset_for_cpu_level(0)
    end

    test "Level 1" do
      assert "superfast" ==
               @codec
               |> ExFfmpegGuide.Transcoder.Codec.preset_for_cpu_level(1)
    end
  end
end
