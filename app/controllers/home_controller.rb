class HomeController < ApplicationController
  def index
  end

  def verify
    if params['verification_code'].eql? current_user.verification_code
      current_user.update(verified: true)
      redirect_to '/', alert: "You are verified!"
    else
      redirect_to '/', alert: "That is not your verification code!"
    end
  end
end
