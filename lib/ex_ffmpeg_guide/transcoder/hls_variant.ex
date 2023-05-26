defmodule ExFfmpegGuide.Transcoder.HlsVariant do
  use Construct do
    field :index, :integer
    field :name, :string, enforce: true
    field :video_passthrough, :boolean, default: false
    field :video_bitrate, :float, enforce: true
    field :audio_passthrough, :boolean, default: false
    field :audio_bitrate, :float, enforce: true
    field :framerate, :integer, enforce: true
    field :cpu_usage_level, :integer, enforce: true
    field :video_size do
      field :width, :integer, enforce: true
      field :height, :integer, enforce: true
    end
  end

  @doc """
  Returns the video bitrate we allocate after making some room for audio.
  """
  def allocated_video_bitrate(%__MODULE__{video_bitrate: video_bitrate}) do
    # Ref: https://github.dev/owncast/owncast/core/transcoder/transcoder.go

    # For limiting the output bitrate
    # https://trac.ffmpeg.org/wiki/Limiting%20the%20output%20bitrate
    # https://developer.apple.com/documentation/http_live_streaming/about_apple_s_http_live_streaming_tools
    # Adjust the max & buffer size until the output bitrate doesn't exceed the ~+10% that Apple's media validator
    # complains about.

    # 192 is pretty average.
    trunc(video_bitrate - 192)
  end

  @doc """
  Returns the maximum video bitrate we allow the encoder to support.
  """
  def max_video_bitrate(v = %__MODULE__{}) do
    v
    |> allocated_video_bitrate()
    |> Kernel.*(1.08)
    |> trunc()
  end

  @doc """
  Returns how often it checks the bitrate of encoded segments to see if it's too high/low.
  """
  def buffer_size(v = %__MODULE__{}) do
    v
    |> max_video_bitrate()
  end
end
