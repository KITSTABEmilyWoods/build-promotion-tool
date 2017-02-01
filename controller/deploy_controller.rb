require_relative '../generator/develop_tag_generator'
require_relative '../generator/other_tag_generator'
require_relative '../helper/user_comms_helper'

class DeployController
  def initialize(environ, user_comms, develop_tag_generator, other_tag_generator)
    @environ = environ
    @user_comms = user_comms
    @develop_tag_generator = develop_tag_generator
    @other_tag_generator = other_tag_generator
  end

  def environment_choice
    @environ.downcase
    @tags_for_this_commit = GitHelper.get_tags_for_this_commit

    case @environ
    when "develop"
      if @other_tag_generator.tag_exists?("dev", @tags_for_this_commit)
        @user_comms.error_commit_has_dev_tag
        return
      end

      unless @develop_tag_generator.develop_tag_exists?
        @user_comms.tell_user_no_develop_tags
        apply_tag(@develop_tag_generator.first_tag)
      else
        to_increment = increment_choice
        next_tag = @develop_tag_generator.next_develop_tag(to_increment)
        apply_tag(next_tag)
      end

    when "test"
      if !@other_tag_generator.tag_exists?("dev", @tags_for_this_commit)
        @user_comms.tell_user_no_tag("dev")
      elsif @other_tag_generator.tag_exists?("test", @tags_for_this_commit)
        @user_comms.tell_user_already_a_tag("test")
      else
        apply_tag(@other_tag_generator.next_tag("dev", "test", @tags_for_this_commit))
      end

    when "stage"
      if !@other_tag_generator.tag_exists?("test", @tags_for_this_commit)
        @user_comms.tell_user_no_tag("test")
      elsif @other_tag_generator.tag_exists?("stage", @tags_for_this_commit)
        @user_comms.tell_user_already_a_tag("stage")
      else
        apply_tag(@other_tag_generator.next_tag("test", "stage", @tags_for_this_commit))
      end
    else
      @user_comms.error_incorrect_environ
    end

    @user_comms.say_thank_you
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

  def apply_tag(next_tag)
    @user_comms.ask_permissison_to_apply(next_tag)
    loop do
      answer = @user_comms.user_reply_y_or_n
      if answer == "y"
        GitHelper.apply_tag(next_tag)
        GitHelper.push_tag_to_remote(next_tag)
      end
      @user_comms.say_no_tag_applied if answer =="n"
      break if ['y', 'n'].include? answer
    end
  end
end
