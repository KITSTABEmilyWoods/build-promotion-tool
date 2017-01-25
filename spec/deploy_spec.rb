require 'rspec'
require_relative '../deploy.rb'

describe 'Deploy' do

  before(:each) do
    @develop_tag_generator = spy('develop_tag_generator')
    @git_helper = spy('git_helper')
    @user_comms = spy('user_comms')
  end

  describe 'environment_choice' do
    describe 'develop' do
      context 'when the user request to apply a new develop tag with patch increment'
      before(:each) do
        @deploy = Deploy.new('develop', @git_helper, @user_comms, @develop_tag_generator,['dev-v0.1.1', 'dev-v0.0.2', 'dev-v0.0.1'])
        allow(@user_comms).to receive(:ask_increment_type)
        allow(@user_comms).to receive(:user_increment_choice).and_return('patch')
        allow(@develop_tag_generator).to receive(:next_develop_tag).with('patch').and_return('dev-v0.1.2')
        allow(@user_comms).to receive(:ask_permissison_to_apply).with('dev-v0.1.2')
      end

      context 'when they say yes to applying the tag' do
        before(:each) do
          allow(@user_comms).to receive(:user_reply_y_or_n).and_return('y')
        end

        it 'receives the next tag to apply' do
          @deploy.environment_choice
          expect(@git_helper).to have_received(:apply_tag).with('dev-v0.1.2')
        end

        it "says 'thank you' to the user" do
          @deploy.environment_choice
          expect(@user_comms).to have_received(:say_thank_you)
        end
      end
      
      context 'when they say no to applying the tag' do
        before(:each) do
          allow(@user_comms).to receive(:user_reply_y_or_n).and_return('n')
        end

        it'says that no tag has been applied' do
          @deploy.environment_choice
          expect(@user_comms).to have_received(:say_no_tag_applied)
        end

        it "says 'thank you' to the user" do
          @deploy.environment_choice
          expect(@user_comms).to have_received(:say_thank_you)
        end
      end
    end
  end
end
