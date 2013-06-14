require 'spec_helper'
require 'tempfile'
require './lib/cane/hashcheck/hash_check'

describe Cane::HashCheck do
  subject { described_class.new hash_glob: file.path }

  let(:file) do
    Tempfile.new('file.rb').tap do |file|
      file.write file_content
      file.flush
    end
  end

  context 'when the file contains hash rockets that should not be there' do
    let(:file_content) do
      <<-RUBY
        { totally: :valid }
        { :not => 'valid' }
        {
          totally: 'valid',
          :not => :valid,
          TOTALLY => :valid,
          LOTS_OF    =>   :whitespace_is_valid,
          18 =>, 1 # this is valid, hash rockets are required for ints
          :no_whitespace=>:still_not_valid
        }
        {
          'also' => 'valid',
          "and also" => 'valid'
        }

        rescue Foobar::Test => valid
      RUBY
    end

    it 'has a violation for each invalid hash rocket' do
      expect(subject.violations.count).to eq 3
    end

    it 'puts the offending file name in the violation' do
      subject.violations.each do |violation|
        expect(violation[:file]).to eq file.path
      end
    end

    it 'puts the offending line number in the violation' do
      expect(subject.violations[0][:line]).to eq 2
      expect(subject.violations[1][:line]).to eq 5
      expect(subject.violations[2][:line]).to eq 9
    end
  end

  context 'when the file has no hashrockets' do
    let(:file_content) do
      <<-RUBY
        { totally: :valid }
        { totally: 'valid' }
      RUBY
    end

    it 'does not have violations' do
      expect(subject.violations).to be_empty
    end
  end
end
