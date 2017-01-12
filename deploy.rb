require './develop_tag_generator'
require './test_tag'
require './git_helper'
require './user_comms'

class Deploy
  def initialize(environ)
    @environ = environ
    @environ.downcase
  end

  def environment_choice
    @git_helper = GitHelper.new #Should be injected
    tags = correctly_formatted_tags(@git_helper.all_tags)
    @user_comms = UserComms.new(STDOUT, STDIN)

    case @environ
    when "develop"
      develop = DevelopTagGenerator.new(tags)
      unless develop.develop_tag_exists?
        @user_comms.tell_user_no_develop_tags
        apply_tag?(develop.first_tag)
        @git_helper.apply_tag(develop.first_tag)  if @user_comms.user_reply_y_or_n == "y"
        return
      end

      to_increment = increment_choice
      next_tag = develop.next_develop_tag(to_increment)
      apply_tag?(next_tag)
      @user_comms.say_thank_you

    when "test"
    when "stage"
    else
    end
  end

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

  def correctly_formatted_tags(tags)
    tags.select {|tag| /^dev|test|stage-v\d+.\d+.\d*$/ =~ tag}
  end
end

deploy = Deploy.new(ARGV[0])
deploy.environment_choice
