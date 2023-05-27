defprotocol ExFfmpegGuide.Transcoder.Hls.Codec do
  alias ExFfmpegGuide.Transcoder.Hls

  use Construct do
  end
  @spec name(t) :: bitstring()
  @doc """
  Name of codec
  """
  def name(codec)

  @spec variant_flags(t, %Hls.Variant{}) :: list(tuple())
  @doc """
  Returns flag list representing a single variant processed by this codec.
  """
  def variant_flags(codec, variant)

  @spec extra_filters(t) :: bitstring()
  @doc """
  Return the extra filters required for this codec in the transcoder
  """
  def extra_filters(codec)

  @spec preset_for_cpu_level(t, integer()) :: bitstring()
  @doc """
  Returns the string preset for this codec given an integer level
  """
  def preset_for_cpu_level(codec, level)

  @doc """
  PixelFormat is the pixel format required for this codec
  """
  @spec pixel_format(t) :: bitstring()
  def pixel_format(codec)

  @spec extra_arguments(t) :: list(tuple())
  @doc """
  the extra arguments used with this codec in the transcoder
  """
  def extra_arguments(codec)
end
