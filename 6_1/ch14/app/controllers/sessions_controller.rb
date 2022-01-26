class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        begin
          ActiveRecord::Base.transaction do
            user.create_user_notification!(Notification::BODY_FIRST_LOGIN)
            user.sign_in_count += 1
            user.save!
          end
        rescue StandardError => e
          Rails.logger.error e
          flash[:warning] = "system error"
          redirect_to(root_url) && return
        end

        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
