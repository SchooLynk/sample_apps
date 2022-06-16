class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :notificatable, polymorphic: true
  belongs_to :parent, class_name: "Notification", optional: true, counter_cache: :children_count

  scope :roots, -> { where parent: nil, children_count: 1.. }
end
