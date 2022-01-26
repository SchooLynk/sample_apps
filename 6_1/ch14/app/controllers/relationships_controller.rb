class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    @user = User.find(params[:followed_id])

    begin
      ActiveRecord::Base.transaction do
        current_user.follow(@user)
        @user.create_user_notification!(Notification::BODY_FOLLOWED, { option_id: current_user.id })
      end
    rescue StandardError => e
      Rails.logger.error e
      flash[:warning] = "system error"
      redirect_to(@user) && return
    end

    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
