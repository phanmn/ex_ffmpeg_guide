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
  def variant_flags(variant, codec)
end
