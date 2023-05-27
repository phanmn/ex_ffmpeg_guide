defmodule ExFfmpegGuide.Transcoder.Hls.FlagsBuilderTest do
  use ExUnit.Case
  require Logger
  alias ExFfmpegGuide.Transcoder
  alias ExFfmpegGuide.Transcoder.Hls

  test "empty" do
    assert [{"var_stream_map", "\"\""}] =
             %Hls{
               variants: [],
               codec: %Hls.Codec.Libx264{},
               latency_level: Hls.LatencyLevel.list() |> Enum.at(0)
             }
             |> Hls.FlagsBuilder.build()
  end

  test "1" do
    assert [{"var_stream_map", "\"\""}] =
             %Hls{
               variants: [
                 %Hls.Variant{
                   name: "1080p",
                   video_passthrough: false,
                   video_bitrate: 8000,
                   audio_passthrough: true,
                   audio_bitrate: 256,
                   framerate: 24,
                   cpu_usage_level: 1,
                   video_size: %{
                     width: 1920,
                     height: 1080
                   }
                 },
                 %Hls.Variant{
                   name: "720p",
                   video_passthrough: false,
                   video_bitrate: 5000,
                   audio_passthrough: true,
                   audio_bitrate: 128,
                   framerate: 24,
                   cpu_usage_level: 1,
                   video_size: %{
                     width: 1280,
                     height: 720
                   }
                 },
                 %Hls.Variant{
                   name: "480p",
                   video_passthrough: false,
                   video_bitrate: 2500,
                   audio_passthrough: true,
                   audio_bitrate: 128,
                   framerate: 24,
                   cpu_usage_level: 1,
                   video_size: %{
                     width: 640,
                     height: 480
                   }
                 }
               ],
               codec: %Hls.Codec.Libx264{},
               latency_level: Hls.LatencyLevel.list() |> Enum.at(0)
             }
             |> Hls.FlagsBuilder.build()
             |> tap(fn flags ->
               flags
               |> Enum.map(fn {key, value} ->
                 "#{key} #{value};"
               end)
               |> Enum.join(" ")
               |> inspect()
               |> Logger.error()
             end)
  end
end
