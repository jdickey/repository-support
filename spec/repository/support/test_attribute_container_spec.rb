# frozen_string_literal: true

require 'spec_helper'

# Test-dummy class to exercise `TestAttributeContainer`.
class TestClass
  extend Repository::Support::TestAttributeContainer

  init_empty_attribute_container
end

describe Repository::Support::TestAttributeContainer do
  let(:obj) { TestClass.new }

  it 'has reader and writer methods for :attributes' do
    expect(obj).to respond_to :attributes
    expect(obj).to respond_to :attributes=
  end

  it 'supports mass initialisation of attributes' do
    obj.attributes = { thing: true, the_answer: 42 }
    expect(obj.thing).to be true
    expect(obj.the_answer).to be 42
  end

  description = 'has new named-attribute accessors added when the name is' \
    ' added to :attributes'
  it description do
    expect { obj.thing }.to raise_error NoMethodError
    expect { obj.thing = false }.to raise_error NoMethodError
    obj.attributes[:thing] = 'something'
    expect { obj.thing }.not_to raise_error
    expect { obj.thing = 'something else' }.not_to raise_error
    expect(obj.thing).to eq 'something else'
  end
end # describe TestClass
