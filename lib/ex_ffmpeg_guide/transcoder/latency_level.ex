defmodule ExFfmpegGuide.Transcoder.LatencyLevel do
  use Construct do
    field :level, :integer
    field :seconds_per_segment, :integer, enforce: true
    field :segment_count, :integer, enforce: true
  end

  def list() do
    [
      # Approx 5 seconds
      %__MODULE__{
        level: 0,
        seconds_per_segment: 1,
        segment_count: 25
      },
      # Approx 8-9 seconds
      %__MODULE__{
        level: 1,
        seconds_per_segment: 2,
        segment_count: 15
      },
      # Default Approx 10 seconds
      %__MODULE__{
        level: 2,
        seconds_per_segment: 3,
        segment_count: 10
      },
      # Approx 15 seconds
      %__MODULE__{
        level: 3,
        seconds_per_segment: 4,
        segment_count: 8
      },
      # Approx 18 seconds
      %__MODULE__{
        level: 4,
        seconds_per_segment: 5,
        segment_count: 5
      },
    ]
  end
end
