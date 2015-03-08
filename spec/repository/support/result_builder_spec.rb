
require 'spec_helper'

describe Repository::Support::ResultBuilder do
  describe 'initialisation' do
    it 'requires one parameter' do
      message = 'wrong number of arguments (0 for 1)'
      expect { described_class.new }.to raise_error ArgumentError, message
    end

    it 'can be initialised with anything' do
      init_values = ['something', nil, 42.7, self]
      init_values.each do |value|
        expect { described_class.new value }.not_to raise_error
      end
    end
  end # describe 'initialisation'

  describe 'has a #build method that' do
    let(:obj) { described_class.new record }

    context 'when the initialiser parameter is truthy' do
      let(:record) { true }
      let(:result) { obj.build }

      describe 'returns a StoreResult instance which' do
        it 'is successful' do
          expect(result).to be_success
        end

        it 'returns the initialiser parameter as its :entity attribute' do
          expect(result.entity).to eq record
        end

        it 'returns an empty Array as its :errors attribute' do
          errors = result.errors
          expect(errors).to respond_to :to_ary
          expect(errors).to be_empty
        end
      end # describe 'returns a StoreResult instance which'
    end # context 'when the initialiser parameter is truthy'

    context 'when the initialiser parameter is falsy' do
      let(:record) { false }

      it 'requires a block' do
        # message = 'no block given (yield)'
        expect { obj.build }.to raise_error LocalJumpError # , message
      end

      describe 'returns a StoreResult instance which' do
        let(:errors_value) { 'RETURNED FROM BLOCK' }
        let(:result) { obj.build { |_r| errors_value } }

        it 'is not successful' do
          expect(result).not_to be_success
        end

        it 'returns an :entity attribute value of nil' do
          expect(result.entity).to be nil
        end

        it 'returns the return value of the block as the :errors attribute' do
          expect(result.errors).to be errors_value
        end
      end # describe 'returns a StoreResult instance which'
    end # context 'when the initialiser parameter is falsy'
  end # describe 'has a #build method that'
end # describe Repository::Support::ResultBuilder
