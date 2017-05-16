require 'spec_helper'

RSpec.describe Rubycomics do
  it 'has a version number' do
    expect(Rubycomics::VERSION).not_to be nil
  end

  describe Rubycomics::User, type: :model do
    it { should have_many :pages }
  end

  describe Rubycomics::Page, type: :model do
    it { should belong_to :user }
  end
end
