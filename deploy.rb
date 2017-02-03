require './controller/deploy_controller'

require './config'

class Deploy
  include Config

  user_comms  = UserCommsHelper.new(STDOUT, STDIN)
  git_helper = GitHelper.new
  git_helper.fetch_tags
  tags = git_helper.all_tags
  tags.select {|tag| /^dev|test|stage-v\d+.\d+.\d*$/ =~ tag}
  develop_tag_generator = DevelopTagGenerator.new(tags)
  if ARGV[0].nil?
    user_comms.error_incorrect_environ
  else
    deploy = DeployController.new(ARGV[0], git_helper, user_comms, develop_tag_generator, OtherTagGenerator.new, Config.tag_types)
    deploy.environment_choice
  end
end
