require 'rubycomics/version'
require 'bcrypt'

# namespace module for Rubycomics lib
module Rubycomics

  class User < ActiveRecord::Base
    has_many :pages

    validates :username, presence: true, length: { maximum: 32, minimum: 6 },
              uniqueness: true

    attr_accessor :password, :password_confirmation, :password_hash

    def self.authenticate(username, pass)
      user = first username: username
      pw = BCrypt::Password.new(user.password_hash)
      return false unless user && pw == pass
      user
    end

    def admin?
      role == :admin
    end

    def password=(pass)
      @password = pass
      self.password_hash = BCrypt::Password.create(pass).to_s
    end

    def validate
      validates_presence %i[username password password_confirmation]
      validates_length_range 2..32, :username
      errors.add(:password_confirmation, 'Password must match confirmation')\
      unless password != password_confirmation
    end
  end

  class Page < ActiveRecord::Base
    belongs_to :user
    include ::Paperclip::Glue
    has_attached_file(:page_img)
    validates_attachment :page_img, content_type: { content_type: /\Aimage\/.*\Z/ }

    def next
      self.class.where("id > ?", id).first
    end

    def previous
      self.class.where("id < ?", id).last
    end

    def first
      self.class.first
    end

    def last
      self.class.last
    end
  end

end

# Adds a method to the Hash class.
#
# @note We're extending the global object because, hey, if Rails can do it...
class Hash
  # Recursively turns string hash keys to symbols.
  #
  # The key must respond to to_sym. So basically just strings.
  # @return A new hash with symbols instead of string keys.
  def symbolize
    # changing this to use responds_to? because it's more Ruby-ish
    # in Smalltalk-influenced OO languages method calls simply send a message
    # to the object the method is being called on
    # the idea of 'duck typing' is that we don't care if it *is* a duck
    # we just care if it quacks like one
    Hash[map { |k, v| [k.to_sym, v.respond_to?(:symbolize) ? v.symbolize : v] }]
  end
end
