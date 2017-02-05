require 'rspec'
require_relative '../controller/deploy_controller.rb'

describe 'DeployController' do

  let(:develop_tag_generator) {spy('develop_tag_generator')}
  let(:git_helper) { spy('git_helper') }
  let(:user_comms) { spy('user_comms') }
  let(:other_tag_generator) { spy('other_tag_generator') }
  let(:tag_types) { { "first_deploy_step" => 'dev', "all_tags" => ['dev', 'test', 'stage'] } }

  describe 'environment_choice' do

    subject(:deploy) {DeployController.new('dev', git_helper, user_comms, develop_tag_generator, other_tag_generator,tag_types)}

    before(:each) do
      allow(git_helper).to receive(:get_tags_for_this_commit)
      tag_types['first_deploy_step']
    end

    describe 'dev_tag' do
      context 'when the user request to apply a new develop tag with patch increment' do
      before(:each) do
        @dev_tag = 'dev-v0.1.2'
        allow(other_tag_generator).to receive(:tag_exists?).and_return(false)
        allow(develop_tag_generator).to receive(:develop_tag_exists?).and_return(true)

        allow(user_comms).to receive(:ask_increment_type)
        allow(user_comms).to receive(:user_increment_choice).and_return('patch')
        allow(develop_tag_generator).to receive(:next_develop_tag).and_return(@dev_tag)
        allow(user_comms).to receive(:ask_permissison_to_apply)
      end

      context 'when they say yes to applying the tag' do
        before(:each) do
          allow(user_comms).to receive(:user_reply_y_or_n).and_return('y')
        end

        it "asks the user's perimission to apply tag dev-v0.1.2" do
          deploy.environment_choice
          expect(user_comms).to have_received(:ask_permissison_to_apply).with(@dev_tag)
        end

        it 'receives the next tag to apply' do
          deploy.environment_choice
          expect(git_helper).to have_received(:apply_tag).with(@dev_tag)
        end

        it 'pushes next tag to the remote' do
          deploy.environment_choice
          expect(git_helper).to have_received(:push_tag_to_remote).with(@dev_tag)
        end

        it "says 'thank you' to the user" do
          deploy.environment_choice
          expect(user_comms).to have_received(:say_thank_you)
        end
      end

      context 'when they say no to applying the tag' do
        before(:each) do
          allow(user_comms).to receive(:user_reply_y_or_n).and_return('n')
        end

        it'says that no tag has been applied' do
          deploy.environment_choice
          expect(user_comms).to have_received(:say_no_tag_applied)
        end

        it "says 'thank you' to the user" do
          deploy.environment_choice
          expect(user_comms).to have_received(:say_thank_you)
        end
      end

      context 'when there is already a develop tag on the commit'do
        before(:each) do
          allow(other_tag_generator).to receive(:tag_exists?).and_return(true)
        end

        it "tells the user that there is already at dev tag on the commit" do
          deploy.environment_choice
          expect(user_comms).to have_received(:error_commit_has_dev_tag)
        end
      end

        context 'when there are no tags on the repository'do
          before(:each) do
            @dev_tag = 'dev-v0.0.1'
            allow(other_tag_generator).to receive(:tag_exists?).and_return(false)
            allow(develop_tag_generator).to receive(:develop_tag_exists?).and_return(false)

            allow(user_comms).to receive(:tell_user_no_develop_tags)
            allow(develop_tag_generator).to receive(:first_tag).and_return(@dev_tag)

            allow(user_comms).to receive(:ask_permissison_to_apply)
            allow(user_comms).to receive(:user_reply_y_or_n).and_return('y')
          end

          it "asks the user's permission to apply the first tag" do
            deploy.environment_choice
            expect(user_comms).to have_received(:ask_permissison_to_apply).with(@dev_tag)
          end

          it "applies the first tag" do
            deploy.environment_choice
            expect(git_helper).to have_received(:apply_tag).with(@dev_tag)
          end

          it "pushes the first tag" do
            deploy.environment_choice
            expect(git_helper).to have_received(:push_tag_to_remote).with(@dev_tag)
          end
        end
      end
    end

    describe 'else' do
      before(:each) do
        @tags_for_this_commit = ['dev-v0.1.1', 'dev-v0.2.0']
        allow(git_helper).to receive(:get_tags_for_this_commit).and_return(@tags_for_this_commit)
        @all_tags = tag_types['all_tags']
      end

      context ' when the user would like to apply a test tag'do

      subject(:deploy) {DeployController.new('test', git_helper, user_comms, develop_tag_generator, other_tag_generator, tag_types)}

      context 'when there is a develop tag, dev-v0.1.5 on the commit' do
        before(:each) do
          @test_tag = 'test-v0.1.5'

          allow(@all_tags).to receive(:include?).and_return(true)
          allow(@all_tags).to receive(:index).and_return(1)

          allow(other_tag_generator).to receive(:tag_exists?).with('dev', @tags_for_this_commit).and_return(true)
          allow(other_tag_generator).to receive(:tag_exists?).with('test', @tags_for_this_commit).and_return(false)

          allow(other_tag_generator).to receive(:next_tag).and_return(@test_tag)

          allow(user_comms).to receive(:ask_permissison_to_apply)
          allow(user_comms).to receive(:user_reply_y_or_n).and_return('y')
        end

        context 'when the user says yes to applying the next tag' do
          before(:each) do
            allow(user_comms).to receive(:user_reply_y_or_n).and_return('y')
          end

          it 'asks permission to apply test tag, test-v0.1.5' do
            deploy.environment_choice
            expect(user_comms).to have_received(:ask_permissison_to_apply).with(@test_tag)
          end

          it 'applies a test tag, test-v0.1.5' do
            deploy.environment_choice
            expect(git_helper).to have_received(:push_tag_to_remote).with(@test_tag)
          end
        end

        context 'when the user says no to applying the next tag' do
          before(:each) do
            allow(user_comms).to receive(:user_reply_y_or_n).and_return('n')
          end

          it 'asks permission to apply test tag, test-v0.1.5' do
            deploy.environment_choice
            expect(user_comms).to have_received(:ask_permissison_to_apply).with(@test_tag)
          end

          it 'says no tag has been applied' do
            deploy.environment_choice
            expect(user_comms).to have_received(:say_no_tag_applied)
          end
        end
        end
      end
    end
  end
end
