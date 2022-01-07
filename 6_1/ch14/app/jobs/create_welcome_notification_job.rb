class CreateWelcomeNotificationJob < ApplicationJob

  def perform(user)
    notification = user.notifications
                       .build(title: "Welcome #{user.name}!")
    notification.save
  end
end
