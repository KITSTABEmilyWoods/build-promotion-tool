require 'rspec'
require_relative '../user_comms'

describe 'UserComms' do
  before(:each) do
    @stdout = spy('STDOUT')
    @stdin = spy('STDIN', gets:'major')
  end

  describe 'initialize' do
    context 'when all class arguments received are null' do
      it 'raises an error' do
        expect { UserComms.new(nil, nil) }.to raise_error.with_message(UserComms::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end

    context 'when STDOUT is null but STDIN is not' do
      it 'raises an error' do
        expect { UserComms.new(nil, @stdin) }.to raise_error.with_message(UserComms::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end

    context 'when STDIN is null but STDOUT is not' do
      it 'raises an error' do
        expect { UserComms.new(@stdout, nil) }.to raise_error.with_message(UserComms::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end
  end

  before(:each) do
    @user_comms = UserComms.new(@stdout, @stdin)
  end

  describe 'tell_user_no_develop_tags' do
    context 'when there are no develop tags in the repository' do
      it 'outputs a response that there are no develop tags' do
        @user_comms.tell_user_no_develop_tags
        expect(@stdout).to have_received(:puts).with(UserComms::TELL_USER_NO_DEVELOP_TAGS)
      end
    end

    describe 'ask_user_to_increment' do
      context 'when the user is asked to select an increment choice' do
        it "outputs 'major, minor, or patch?' to the console" do
          @user_comms.ask_increment_type
          expect(@stdout).to have_received(:puts).with(UserComms::ask_increment_type)
        end
      end
    end

    describe 'user_increment_choice' do
      before(:each) do
        allow(@stdin).to receive(:gets).and_return("major")
      end

      context 'when the user inputs their increment choice as major' do
        it "should accept the user's input as 'major'" do
          expect(@user_comms.user_increment_choice).to eq("major")
        end

        it "should not return minor as a response" do
          expect(@user_comms.user_increment_choice).not_to eql("minor")
        end
      end

      context "when the user inputs a choice which is not major, minor, or patch" do
        it "returns an error asking the user to choose major, minor, or patch" do
          allow(@stdin).to receive(:gets).and_return("hello")
          @user_comms.user_increment_choice
          expect(@stdout).to have_received(:puts).with(UserComms::ERROR_SELECT_ACCEPTED_INCREMENT_TYPE)
        end
      end
    end

    describe 'ask_permissison_to_apply' do
      context 'when asked permission to apply tag: dev-v1.1.1' do
        before(:each) do
          @next_tag = "dev-v1.1.1"
        end

        it 'asks if user would like to apply the next tag' do
          @user_comms.ask_permissison_to_apply(@next_tag)
          expect(@stdout).to have_received(:puts).with("Do you want to apply develop tag: #{@next_tag}? - y/n")
        end
      end

      context 'when a null value is received for the next tag' do
        before(:each) do
          @next_tag = nil
        end

        it 'raises an exception if no value assigned to tag' do
          expect{@user_comms.ask_permissison_to_apply(@next_tag)}.to raise_error.with_message(UserComms::ERROR_NEXT_TAG_NOT_ASSIGNED)
        end
      end
    end

    describe 'user_reply_y_or_n' do
      context "when the user inputs their choice as yes 'y'" do
        it "should accept the user's input as 'y'" do
          allow(@stdin).to receive(:gets).and_return("y")
          expect(@user_comms.user_reply_y_or_n).to eq("y")
        end

        it "should not accept the user's input as negative, 'n'" do
          allow(@stdin).to receive(:gets).and_return("y")
          expect(@user_comms.user_reply_y_or_n).not_to eql("n")
        end
      end

      context "when the user inputs their choice as something other than 'y' or 'n'" do
        it "returns an error telling the user that they need to input yes or no" do
          allow(@stdin).to receive(:gets).and_return('u')
          @user_comms.user_reply_y_or_n
          expect(@stdout).to have_received(:puts).with(UserComms::ERROR_SELECT_Y_OR_N)
        end
      end

      describe 'say_thank_you' do
        context 'when the user has made a decision' do
          it 'outputs thank you' do
            @user_comms.say_thank_you
            expect(@stdout).to have_received(:puts).with("Thank you!")
          end
        end
      end
    end
  end
end
