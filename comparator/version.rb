class Version
  include Comparable
  attr_accessor :major, :minor, :patch

  def initialize(version_string)
    array = version_string.split(".")
    self.major = array[0].to_i
    self.minor = array[1].to_i
    self.patch = array[2].to_i
  end

  def ==(other)
    other.class == self.class && other.major == self.major && other.minor == self.minor && other.patch == self.patch
  end

  def <=>(other)
    return nil if self.class != other.class
    [self.major, self.minor, self.patch] <=> [other.major, other.minor, other.patch]
  end
end
