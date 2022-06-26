class FirstLoginNotice < ApplicationRecord
  belongs_to :user
  
  # NOTE: 未読: 0, 既読: 1
  enum read: { yet: 0, already: 1 }
end
