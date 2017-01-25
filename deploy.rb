require './develop_tag_generator'
require './test_tag'
require './git_helper'
require './user_comms'

class Deploy
  def initialize(environ, git_helper, user_comms, develop_tag_generator, tags)
    @environ = environ
    @git_helper = git_helper
    @user_comms = user_comms
    @develop_tag_generator = develop_tag_generator
    @tags = tags
  end

  def environment_choice
    @environ.downcase
    case @environ
    when "develop"
      unless @develop_tag_generator.develop_tag_exists?
        @user_comms.tell_user_no_develop_tags
        apply_tag?(@develop_tag_generator.first_tag)
      else
        to_increment = increment_choice
        next_tag = @develop_tag_generator.next_develop_tag(to_increment)
        apply_tag?(next_tag)
      end
      @user_comms.say_thank_you
    when "test"
    when "stage"
    else
      "what"
    end
  end

  private
  def increment_choice
    loop do
      @user_comms.ask_increment_type
      @to_increment = @user_comms.user_increment_choice
      break if ['major', 'minor', 'patch'].include? @to_increment
    end
    @to_increment
  end

  def apply_tag?(next_tag)
    @user_comms.ask_permissison_to_apply(next_tag)
    loop do
      answer = @user_comms.user_reply_y_or_n
      @git_helper.apply_tag(next_tag) if answer == "y"
      @user_comms.say_no_tag_applied if answer =="n"
      break if ['y', 'n'].include? answer
    end
  end
end

git_helper = GitHelper.new
user_comms  = UserComms.new(STDOUT, STDIN)
tags = git_helper.all_tags
tags.select {|tag| /^dev|test|stage-v\d+.\d+.\d*$/ =~ tag}
develop_tag_generator = DevelopTagGenerator.new(tags)
if ARGV[0].nil?
  user_comms.error_no_environ_selected
else
  deploy = Deploy.new(ARGV[0], git_helper, user_comms, develop_tag_generator,tags)
  deploy.environment_choice
end
