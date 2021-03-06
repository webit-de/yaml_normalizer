# frozen_string_literal: true

require 'spec_helper'

RSpec.describe YamlNormalizer::Ext::Namespaced do
  context 'extended Hash instances with "namespaced"' do
    subject { hash.extend(described_module).namespaced }
    let(:described_module) { described_class }
    let(:hash) { { b: { z: 20, x: 10 }, a: nil } }

    it 'does not modify the original object' do
      expect { subject }.to_not(change { hash })
    end

    it 'converts a Hash from a tree structure to a plain key-value' do
      expect(subject).to eql('b.z' => 20, 'b.x' => 10, 'a' => nil)
    end
  end

  it 'does not modify Ruby Core class Hash' do
    expect { {}.namespaced }.to raise_error(NoMethodError)
  end
end
