#!/usr/bin/env ruby

class Deploy
  environ = ARGV[0] #ARGV only for files?
  environ.downcase

  def choice
    case environ
    when "dev"
      develop
    when "test"
      puts "test"
    when "stage"
      puts "stage"
    else
      STDERR.puts
    end
  end

  def develop
    system('git log')
    STDOUT.puts "Major, minor, patch?\n"
    choice = STDIN.gets.chomp
    case choice
      when "major"
        puts "you picked major"

      when "minor"
        puts "you picked minor"
      when "patch"
        puts "you picked patch"
      else
        puts choice
    end
  end

  def check_git_history

  end

  def test
  end

  def stage
  end
end

deploy = Deploy.new
deploy.develop
