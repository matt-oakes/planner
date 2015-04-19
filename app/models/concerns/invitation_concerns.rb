module InvitationConcerns
  extend ActiveSupport::Concern

  included do
    include InstanceMethods

    belongs_to :member

    before_create :set_token

    validates :token, uniqueness: true

    scope :accepted, ->  { where(attending: true) }
    scope :not_accepted, ->  { where("attending is NULL or attending = false") }

  end

  module InstanceMethods
    def to_param
      token
    end

    def for_student?
      role.eql?("Student")
    end

    def for_coach?
      role.eql?("Coach")
    end

    private

    def set_token
      self.token = loop do
        random_token = SecureRandom.urlsafe_base64(nil, false)
        break random_token unless self.class.where(token: random_token).exists?
      end
    end
  end
end
