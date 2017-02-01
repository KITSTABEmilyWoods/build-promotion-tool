require './controller/deploy_controller'
require './helper/git_helper'

include GitHelper

class Deploy
  user_comms  = UserCommsHelper.new(STDOUT, STDIN)
  GitHelper.fetch_tags
  tags = GitHelper.all_tags
  tags.select {|tag| /^dev|test|stage-v\d+.\d+.\d*$/ =~ tag}
  develop_tag_generator = DevelopTagGenerator.new(tags)
  if ARGV[0].nil?
    user_comms.error_incorrect_environ
  else
    deploy = DeployController.new(ARGV[0], user_comms, develop_tag_generator, OtherTagGenerator.new)
    deploy.environment_choice
  end
end
