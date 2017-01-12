class GitHelper

  def all_tags
    `git tag -l`.lines
  end

  def apply_tag(tag)
    `git tag #{tag}`
  end

  def push_tag
    
  end

end

# g = GitHelper.new
# g.apply_tag('dev-v5.5.5')
