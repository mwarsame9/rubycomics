require 'spec_helper'

RSpec.describe Rubycomics do
  it 'has a version number' do
    expect(Rubycomics::VERSION).not_to be nil
  end

  describe Rubycomics::User do
    it { should have_many :pages}
  end

  describe Rubycomics::Page do
    it { should belong_to :user}
  end
end
