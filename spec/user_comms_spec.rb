require 'rspec'
require_relative '../helper/user_comms_helper.rb'

describe 'UserCommsHelper' do
  let(:stdout) {spy('STDOUT')}
  let(:stdin) {spy('STDIN')}

  describe 'initialize' do
    context 'when all class arguments received are null' do
      it 'raises an error' do
        expect { UserCommsHelper.new(nil, nil) }.to raise_error.with_message(UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end

    context 'when STDOUT is null but STDIN is not' do
      it 'raises an error' do
        expect { UserCommsHelper.new(nil, stdin) }.to raise_error.with_message(UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end

    context 'when STDIN is null but STDOUT is not' do
      it 'raises an error' do
        expect { UserCommsHelper.new(stdout, nil) }.to raise_error.with_message(UserCommsHelper::ERROR_INITIALISE_WITH_STRING_IO)
      end
    end
  end

  subject(:user_comms) { UserCommsHelper.new(stdout, stdin) }

  describe 'tell_user_no_develop_tags' do
    context 'when there are no develop tags in the repository' do
      it 'outputs a response that there are no develop tags' do
        user_comms.tell_user_no_develop_tags
        expect(stdout).to have_received(:puts).with(UserCommsHelper::TELL_USER_NO_DEVELOP_TAGS)
      end
    end

    describe 'ask_user_to_increment' do
      context 'when the user is asked to select an increment choice' do
        it "outputs 'major, minor, or patch?' to the console" do
          user_comms.ask_increment_type
          expect(stdout).to have_received(:puts).with(UserCommsHelper::ASK_USER_INCREMENT_TYPE)
        end
      end
    end

    describe 'user_increment_choice' do
      before(:each) do
        allow(stdin).to receive(:gets).and_return("major")
      end

      context 'when the user inputs their increment choice as major' do
        it "should accept the user's input as 'major'" do
          expect(user_comms.user_increment_choice).to eq("major")
        end

        it "should not return minor as a response" do
          expect(user_comms.user_increment_choice).not_to eql("minor")
        end
      end

      context "when the user inputs a choice which is not major, minor, or patch" do
        it "returns an error asking the user to choose major, minor, or patch" do
          allow(stdin).to receive(:gets).and_return("hello")
          user_comms.user_increment_choice
          expect(stdout).to have_received(:puts).with(UserCommsHelper::ERROR_SELECT_ACCEPTED_INCREMENT_TYPE)
        end
      end
    end

    describe 'ask_permissison_to_apply' do
      context 'when asked permission to apply tag: dev-v1.1.1' do
        before(:each) do
          @next_tag = "dev-v1.1.1"
        end

        it 'asks if user would like to apply the next tag' do
          user_comms.ask_permissison_to_apply(@next_tag)
          expect(stdout).to have_received(:puts).with("Do you want to apply tag: #{@next_tag}? - y/n")
        end
      end

      context 'when a null value is received for the next tag' do
        before(:each) do
          @next_tag = nil
        end

        it 'raises an exception if no value assigned to tag' do
          expect{user_comms.ask_permissison_to_apply(@next_tag)}.to raise_error.with_message(UserCommsHelper::ERROR_NEXT_TAG_NOT_ASSIGNED)
        end
      end
    end

    describe 'user_reply_y_or_n' do
      context "when the user inputs their choice as yes 'y'" do
        it "should accept the user's input as 'y'" do
          allow(stdin).to receive(:gets).and_return("y")
          expect(user_comms.user_reply_y_or_n).to eq("y")
        end

        it "should not accept the user's input as negative, 'n'" do
          allow(stdin).to receive(:gets).and_return("y")
          expect(user_comms.user_reply_y_or_n).not_to eql("n")
        end
      end

      context "when the user inputs their choice as something other than 'y' or 'n'" do
        it "returns an error telling the user that they need to input yes or no" do
          allow(stdin).to receive(:gets).and_return('u')
          user_comms.user_reply_y_or_n
          expect(stdout).to have_received(:puts).with(UserCommsHelper::ERROR_SELECT_Y_OR_N)
        end
      end
    end

    describe 'tell_user_no_tag'do
     context 'when the there are no develop tags on the commit' do
       @tag_type = 'develop'
       it 'tells the user that there is no develop tag' do
         user_comms.tell_user_no_tag(@tag_type)
         expect(stdout).to have_received(:puts).with("Error: there are no previous #{@tag_type} tags on this commit")
       end
     end
    end

    describe 'tell_user_already_a_tag'do
     context 'when there is already a test tag on the commit' do
       @tag_type = 'test'
       it 'tells the user that there is already a test tag' do
         user_comms.tell_user_already_a_tag(@tag_type)
         expect(stdout).to have_received(:puts).with("Error: There is already a #{@tag_type} tag on this commit")
       end
     end
    end

    describe 'say_thank_you' do
      context 'when the user has made a decision' do
        it 'outputs thank you' do
          user_comms.say_thank_you
          expect(stdout).to have_received(:puts).with("Thank you!")
        end
      end
    end
  end
end
