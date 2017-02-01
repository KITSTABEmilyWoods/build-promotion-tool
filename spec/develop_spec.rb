require 'rspec'
require_relative '../generator/develop_tag_generator'

describe 'DevelopTagGenerator' do
  describe 'develop_tag_exists' do
    context 'When there are no tags' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new([]) }

      it 'says that there are no develop tags' do
        expect(develop_tag_generator.develop_tag_exists?).to eql(false)
      end
    end

    context 'When there is a develop tag' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new(['dev-v0.1.1']) }

      it 'says there is a develop tag' do
        expect(develop_tag_generator.develop_tag_exists?).to eql(true)
      end
    end

    context 'When there is a tag kind of like dev-v0.1.1' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new(['dev-v0.1.1fjasjafsjaf']) }

      it "says there isn't a develop tag" do
        expect(develop_tag_generator.develop_tag_exists?).to eql(false)
      end
    end

    context 'When there is a test tag' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new(['test-v0.1.1']) }

      it "says there isn't a develop tag" do
        expect(develop_tag_generator.develop_tag_exists?).to eql(false)
      end
    end

    context 'When there are multiple tags and one develop tag' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new(['test-v0.1.1', 'stage-v0.0.1', 'hello', 'dev-v0.0.1']) }

      it 'says there is a develop tag' do
        expect(develop_tag_generator.develop_tag_exists?).to eql(true)
      end
    end
  end

  describe 'first_tag' do
    subject(:develop_tag_generator) { DevelopTagGenerator.new([]) }

    context 'When the first develop tag is required' do
      it 'says the first develop tag is dev-v0.0.1' do
        expect(develop_tag_generator.first_tag).to match('dev-v0.0.1')
      end

      it 'says the first develop tag is not blank' do
        expect(develop_tag_generator.first_tag).not_to match(" ")
      end
    end
  end

  describe 'next_develop_tag' do
    context 'When there are multiple tags' do
      subject(:develop_tag_generator) { DevelopTagGenerator.new(['hello', 'test-v0.0.1', 'dev-v0.0.1', 'dev-v1.1.1', 'dev-v0.0.1']) }

      it 'returns the next version for major update' do
        next_tag = develop_tag_generator.next_develop_tag("major")
        expect(next_tag).to eq("dev-v2.0.0")
      end

      it 'returns the next version for minor update' do
        next_tag = develop_tag_generator.next_develop_tag("minor")
        expect(next_tag).to eq("dev-v1.2.0")
      end

      it 'returns the next version for patch update' do
        next_tag = develop_tag_generator.next_develop_tag("patch")
        expect(next_tag).to eq("dev-v1.1.2")
      end
    end
  end
end
