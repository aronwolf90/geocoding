class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
    @user = User.new
  end

  def create
    @user = User.new(registration_params)

    if @user.save
      redirect_to new_session_path,
        notice: "You have been successfully registered. You can now sign in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def registration_params
      params.expect(
        user: %i[ email_address password password_confirmation street zip_code city country ]
      )
    end
end
