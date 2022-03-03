namespace :user do
  desc 'unite recent notifications'
  task unite_recent_notifications: :environment do |_task, category, minutes = Notification::MINUTES|
    User.all.each do |user|
      user.unite_recent_notifications(
        Notification.categories[:followed],
        minutes
      )
    end
  end
end
