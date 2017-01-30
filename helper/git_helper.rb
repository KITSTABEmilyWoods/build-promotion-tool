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

  def fetch_tags
    `git fetch --tags`
  end

  def push_tag_to_remote
    `git push origin HEAD`
  end


end

git_helper = GitHelper.new
git_helper.push_tag_to_remote
