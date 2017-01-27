require_relative '../comparator/version'

class DevelopTagGenerator
  def initialize(tags)
    @tags = tags
  end

  def first_tag
    "dev-v0.0.1"
  end

  def next_develop_tag(to_increment)
    last_version = biggest_version
    case to_increment
    when "major"
      "dev-v#{last_version.major + 1}.0.0"
    when "minor"
      "dev-v#{last_version.major}.#{last_version.minor + 1}.0"
    when "patch"
      "dev-v#{last_version.major}.#{last_version.minor}.#{last_version.patch + 1}"
    end
  end

  def develop_tag_exists?
    @tags.any? { |tag| /^dev-v\d+.\d+.\d*$/ =~ tag }
  end

  private

  def biggest_version
    @tags.select { |tag| /^dev-v\d+.\d+.\d*$/ =~ tag }
         .map { |tag| tag.split("-v")[1] }
         .map { |version_string| Version.new(version_string) }
         .max
  end
end
