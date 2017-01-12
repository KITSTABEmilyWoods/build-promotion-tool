class TestTag

  def add_test_tag
    if !list_commit_tags.empty? && !check_for_dev_tag.empty?
      apply_tag
    else
      STDOUT.puts "ERROR: No develop tags have been assigned to this commit.
      \n Check all tags assigned to this commit with:\
      \n git tag --points-at HEAD
      \n"
    end
  end

  def list_commit_tags
    list_tags = `git tag --points-at HEAD`
    list_each_tag =list_tags.split("\n")
    return list_each_tag
  end

  def get_tag_env_types
    commit_tags = list_commit_tags
    i = 0
    tag_type = []
    while i < commit_tags.length
      tag_split = commit_tags[i].split("-v")
      tag_type.push(tag_split[0])
      i+=1
    end
    return tag_type
  end

  def check_for_dev_tag
    tag_split = get_tag_env_types
    count =[]
    tag_split.each do |env_type|
      if env_type == "dev"
        count.push(1)
      end
    end
    return count
  end

  def get_tag_number
    commit_tags = list_commit_tags
    tag_split = commit_tags[0].split("-v")
    tag_number = tag_split[1]
    return tag_number
  end

  def assign_new_tag_num
    tag_number = get_tag_number
    new_test_tag = "test-v" + tag_number
    return new_test_tag
  end

  def apply_tag
    new_tag = assign_new_tag_num
    puts new_tag
    STDOUT.puts new_tag
    `git tag #{new_tag}`
  end
end
