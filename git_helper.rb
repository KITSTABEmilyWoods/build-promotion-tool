class GitHelper

  def all_tags
    `git tag -l`.lines
  end

  def apply_tag(tag)
    `git tag #{tag}`
  end

  def get_tags_for_this_commit
    `git tag --points-at HEAD`.lines
  end

  def push_tag

  end

end
