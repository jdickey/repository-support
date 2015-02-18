
require 'spec_helper'
require 'active_model'

describe Repository::Support::ErrorFactory do
  it 'has a .create class method' do
    expect { described_class.method :create }.not_to raise_error
  end

  describe 'has a .create class method that, when called' do
    let(:errors) { ActiveModel::Errors.new self }
    let(:actual) { described_class.create errors }

    context 'with an empty Errors object' do
      it 'returns an empty array' do
        expect(actual).to respond_to :to_ary
        expect(actual).to be_empty
      end
    end # context 'with an empty Errors object'

    context 'with an Errors object containing errors' do
      let(:samples) do
        [
          { field: 'field1', message: 'is invalid' },
          { field: 'field1', message: 'is empty or blank' },
          { field: 'field2', message: 'is :field2' }
        ]
      end

      before :each do
        samples.each { |sample| errors.add sample[:field], sample[:message] }
      end

      it 'returns an array with the correct error hashes' do
        expect(actual).to eq samples
      end
    end # context 'with an Errors object containing errors'
  end # describe 'has a .create class method that, when called'
end # describe Repository::Support::ErrorFactory
