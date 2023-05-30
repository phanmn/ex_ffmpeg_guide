defmodule ExFfmpegGuide.TranscoderTest do
  use ExUnit.Case
  require Logger

  alias ExFfmpegGuide.Transcoder
  alias ExFfmpegGuide.Transcoder.Output.Hls

  test "args" do
    output = "-i rtmp://localhost:1935/live/livestream -map v:0 -c:v:0 libx264 -b:v:0 7808k -maxrate:v:0 8432k -g:v:0 24 -keyint_min:v:0 24 -r:v:0 24 -x264-params:v:0 \"scenecut=0:open_gop=0\" -bufsize:v:0 8432 -profile:v:0 high -map a:0? -c:a:0 copy -sws_flags bilinear -filter:v:0 \"scale='min(1920,iw)':'min(1080,ih)'\" -preset superfast -var_stream_map \"v:0,a:0,name:1080p\" -f hls -hls_time 1 -hls_list_size 25 -hls_delete_threshold 50 -hls_flags delete_segments+independent_segments+program_date_time -segment_format_options mpegts_flags=mpegts_copyts=1 -tune zerolatency -pix_fmt yuv420p -sc_threshold 0 -master_pl_name stream.m3u8 -y live/%v/stream.m3u8"
    assert output == %Transcoder{
      outputs: [
        %Transcoder.Output.Hls{
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
            }
          ],
          codec: %Hls.Codec.Libx264{},
          latency_level: Hls.LatencyLevel.list() |> Enum.at(0),
          output: "live/%v/stream.m3u8"
        }
      ],
      input: %Transcoder.Input.Rtmp{
        url: "rtmp://localhost:1935/live/livestream"
      }
    }
    |> Transcoder.to_args()
    |> Enum.map(fn {key, value} ->
      "-#{key} #{value}"
    end)
    |> Enum.join(" ")
    # |> inspect()
    # |> Logger.error()
  end
end
