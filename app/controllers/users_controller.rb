class UsersController < ApplicationController
  def show
    @user = Current.user
  end
end
