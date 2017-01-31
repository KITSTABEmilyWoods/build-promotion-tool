require_relative '../comparator/version'

class OtherTagGenerator

  def tag_exists?(check_tag_type, tags_for_this_commit)
    tags_for_this_commit.any? {|tag| /^#{check_tag_type}-v\d+.\d+.\d*$/ =~ tag}
  end

  def next_tag(previous_tag_type, next_tag_type, tags_for_this_commit)
    tags_for_this_commit.select {|tag| /^#{previous_tag_type}-v\d+.\d+.\d*$/ =~ tag}
                        .map {|tag| tag.sub(previous_tag_type, next_tag_type)}
                        .map {|tag| tag.sub(/\n/, "")}
                        .first
  end

end
