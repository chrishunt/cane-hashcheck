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
          :not  =>  :valid,
          TOTALLY => :valid
        }
        { 'also' =>  'valid' }
      RUBY
    end

    it 'has a violation for each hash rocket' do
      expect(subject.violations.count).to eq 2
    end

    it 'returns the offending file names' do
      subject.violations.each do |violation|
        expect(violation[:file]).to eq file.path
      end
    end

    it 'returns the offending file lines' do
      expect(subject.violations[0][:line]).to eq 2
      expect(subject.violations[1][:line]).to eq 5
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
