class UserComms

  ERROR_INITIALISE_WITH_STRING_IO = "Initialise with StringIO objects"
  TELL_USER_NO_DEVELOP_TAGS = "No develop tags exist for this repository"
  ASK_USER_INCREMENT_TYPE = "Would you like to do a major, minor, or patch increment?"
  ERROR_SELECT_ACCEPTED_INCREMENT_TYPE = "Error: please select major, minor or patch update"
  ERROR_NEXT_TAG_NOT_ASSIGNED = "Next tag has not been assigned"
  ERROR_SELECT_Y_OR_N = "Error: please select y/n"

  def initialize(stdout, stdin)
    @stdout = stdout if stdout.respond_to?(:puts)
    @stdin = stdin if stdin.respond_to?(:gets)
    raise ERROR_INITIALISE_WITH_STRING_IO if @stdout.nil? || @stdin.nil?
  end

  def tell_user_no_develop_tags
    @stdout.puts TELL_USER_NO_DEVELOP_TAGS
  end

  def ask_increment_type
    @stdout.puts ASK_USER_INCREMENT_TYPE
  end

  def user_increment_choice
    increment_choice = @stdin.gets.chomp().downcase
    if increment_choice == "major" || increment_choice == "minor" || increment_choice == "patch"
      return increment_choice
    else
      @stdout.puts ERROR_SELECT_ACCEPTED_INCREMENT_TYPE
    end
  end

  def ask_permissison_to_apply(next_tag)
    raise ERROR_NEXT_TAG_NOT_ASSIGNED if next_tag.nil?
    @stdout.puts "Do you want to apply develop tag: #{next_tag}? - y/n"
  end

  def user_reply_y_or_n
    user_choice = @stdin.gets.chomp().downcase
    if user_choice == "y" || user_choice == "n"
      return user_choice
    else
      @stdout.puts ERROR_SELECT_Y_OR_N
    end
  end

  def say_thank_you
    @stdout.puts "Thank you!"
  end

  def say_no_tag_applied
    @stdout.puts "No tag applied"
  end
end
