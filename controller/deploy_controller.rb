require_relative '../generator/develop_tag_generator'
require_relative '../generator/other_tag_generator'
require_relative '../helper/git_helper'
require_relative '../helper/user_comms_helper'

class DeployController

  attr_accessor :environ, :tag_types, :git_helper, :user_comms, :develop_tag_generator, :other_tag_generator

  def initialize(environ, git_helper, user_comms, develop_tag_generator, other_tag_generator, tag_types)
    self.environ = environ
    self.tag_types = tag_types
    self.git_helper = git_helper
    self.user_comms = user_comms
    self.develop_tag_generator = develop_tag_generator
    self.other_tag_generator = other_tag_generator
  end

  def environment_choice
    environ.downcase
    @tags_for_this_commit = git_helper.get_tags_for_this_commit
    dev_tag = tag_types['first_deploy_step']
    all_tags = tag_types['all_tags']

    case environ
    when dev_tag
      if other_tag_generator.tag_exists?(dev_tag, @tags_for_this_commit)
        @user_comms.error_commit_has_dev_tag
        return
      end

      unless develop_tag_generator.develop_tag_exists?
        @user_comms.tell_user_no_develop_tags
        apply_tag(develop_tag_generator.first_tag)
      else
        to_increment = increment_choice
        next_tag = develop_tag_generator.next_develop_tag(to_increment)
        apply_tag(next_tag)
      end

    else
      if all_tags.include? environ
        last_tag_index = all_tags.index(environ) - 1
        last_tag_type = all_tags[last_tag_index]
        select_next_tag(last_tag_type, environ)
      else
        @user_comms.error_incorrect_environ
        return
      end

    end
    @user_comms.say_thank_you
  end

  private

  def select_next_tag(last_tag_type, next_tag_type)
    if !other_tag_generator.tag_exists?(last_tag_type, @tags_for_this_commit)
      @user_comms.tell_user_no_tag(last_tag_type)
    elsif other_tag_generator.tag_exists?(next_tag_type, @tags_for_this_commit)
      @user_comms.tell_user_already_a_tag(next_tag_type)
    else
      apply_tag(other_tag_generator.next_tag(last_tag_type, next_tag_type, @tags_for_this_commit))
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

  def apply_tag(next_tag)
    @user_comms.ask_permissison_to_apply(next_tag)
    loop do
      answer = @user_comms.user_reply_y_or_n
      if answer == "y"
        git_helper.apply_tag(next_tag)
        git_helper.push_tag_to_remote(next_tag)
      end
      @user_comms.say_no_tag_applied if answer =="n"
      break if ['y', 'n'].include? answer
    end
  end
end
