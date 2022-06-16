class SignedIn < ApplicationRecord
  include Notificatable

  attr_accessor :last_signed_in_ip

  belongs_to :user

  after_create :notify

  def notify
    x = build_notification user: user unless last_signed_in_ip
    x.parent = parent_notification user, x
    x.save
  end
end
