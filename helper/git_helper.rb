class GitHelper

  def fetch_tags
    `git fetch --tags`
  end

  def all_tags
    `git tag -l`.lines
  end

  def get_tags_for_this_commit
    `git tag --points-at HEAD`.lines
  end

  def apply_tag(tag)
    `git tag #{tag}`
  end

  def push_tags_to_remote(tag)
    `git push origin #{tag}`
  end

end

g = GitHelper.new
g.push_tags_to_remote('dev-v4.4.4')
