require 'spec_helper'

describe Differ do
  it 'has a version number' do
    expect(Differ::VERSION).not_to be nil
  end

  it 'must build root path' do
    expect(Differ.root_path).not_to be nil
  end
end
