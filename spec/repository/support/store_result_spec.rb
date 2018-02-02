# frozen_string_literal: true

require 'spec_helper'

describe Repository::Support::StoreResult do
  describe 'initialisation' do
    it 'requires three keyword-named parameters' do
      # message = 'missing keywords: entity, success, errors'
      expect { described_class.new }.to raise_error ArgumentError # , message
    end

    it 'succeeds with specified values that can then be read back correctly' do
      entity = 'ENTITY'
      success = 'SUCCESS'
      errors = 'ERRORS'
      obj = described_class.new entity: entity, success: success, errors: errors
      expect(obj.entity).to eq entity
      expect(obj.success).to eq success
      expect(obj.errors).to eq errors
    end
  end # describe 'initialisation'

  describe 'has a #success? method that' do
    it 'returns the same object as the #success accessor method' do
      obj = described_class.new entity: nil, success: 'SUCCESS', errors: nil
      # Note the difference between 'to be' and 'to eq'.
      expect(obj.success?).to be obj.success
    end
  end # describe 'has a #success? method that'
end # describe Repository::Support::StoreResult

describe Repository::Support::StoreResult::Success do
  let(:entity) { Object.new }
  let(:obj) { described_class.new entity }

  describe 'returns' do
    it 'true from its #success accessor method' do
      expect(obj.success).to be true
      expect(obj).to be_success
    end

    it 'the specified entity from its #entity accessor method' do
      expect(obj.entity).to be entity
    end

    it 'an empty array from its #errors accessor method' do
      expect(obj.errors).to eq []
    end
  end # describe 'returns'
end # describe Repository::Support::StoreResult::Success

describe Repository::Support::StoreResult::Failure do
  let(:errors) { 'ERRORS' }
  let(:obj) { described_class.new errors }

  describe 'returns' do
    it 'false from its #success accessor method' do
      expect(obj.success).not_to be true
      expect(obj).not_to be_success
    end

    it 'nil from its #entity accessor method' do
      expect(obj.entity).to be nil
    end

    it 'the passed-in :errors parameter from its #errors accessor method' do
      expect(obj.errors).to be errors
    end
  end # describe 'returns'
end # describe Repository::Support::StoreResult::Failure
