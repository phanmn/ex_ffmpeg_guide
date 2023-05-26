defprotocol ExFfmpegGuide.Transcoder.Codec do
  use Construct do
  end
  @doc """
  Name of codec
  """
  def name(codec)

  @doc """
  Returns flag list representing a single variant processed by this codec.
  """
  def variant_flags(codec, variant)

  @doc """
  Return the extra filters required for this codec in the transcoder
  """
  def extra_filters(codec)

  @doc """
  Returns the string preset for this codec given an integer level
  """
  def preset_for_cpu_level(codec, level)
end
