require 'rspec'
require_relative '../generator/other_tag_generator'

describe 'OtherTagGenerator' do
  subject(:other_tag_generator) { OtherTagGenerator.new }

  describe 'tag_exists?' do
    before(:each) do
      @check_tag_type = 'dev'
    end

    context 'when there are no develop tags on the commit but there are other tags' do
      it 'says there are no develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['test-v1.1.1', 'test-v1.2.1'])).to eql(false)
      end
    end

    context 'when there are no tags on the commit' do
      it 'says there are no develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, [])).to eql(false)
      end
    end

    context 'when there is a develop tag on the commit' do
      it 'says there is a develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['dev-v0.1.1'])).to eql(true)
      end
    end

    context 'when there is both a develop and test tag on the commit' do
      it 'says there is a develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['dev-v0.1.1', 'test-v0.1.1'])).to eql(true)
      end
    end

    context 'when there is a tag kind of like deveop' do
      it 'says there is a develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['dev-v0.1.1adljalal'])).to eql(false)
      end
    end

    context 'when there is a different tag type' do
      it 'says there is a develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['hello'])).to eql(false)
      end
    end

    context 'when there are more than one dev tags' do
      it 'says there is a develop tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['dev-v0.1.1', 'dev-v0.1.2'])).to eql(true)
      end
    end

    context 'when there is already a test tag' do
      before(:each) do
        @check_tag_type = 'test'
      end

      it 'says there is a test tag' do
        expect(other_tag_generator.tag_exists?(@check_tag_type, ['test-v0.1.1'])).to eql(true)
      end
    end
  end

  describe 'next_tag' do
    before(:each) do
      @previous_tag_type = 'dev'
      @next_tag_type  = 'test'
    end

    context 'when there is a develop tag: dev-v0.1.1' do
      it 'returns a test tag: test-v0.1.1' do
        expect(other_tag_generator.next_tag(@previous_tag_type, @next_tag_type, ['dev-v0.1.1'])).to eql('test-v0.1.1')
      end
    end

    context 'when there are more than one dev tags' do
      it 'returns the first' do
        expect(other_tag_generator.next_tag(@previous_tag_type, @next_tag_type,['dev-v0.1.1', 'dev-v0.1.2', 'dev-v0.2.1'])).to eql('test-v0.1.1')
      end
    end

  end
end
