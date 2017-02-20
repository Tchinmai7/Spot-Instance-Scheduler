class WelcomeController < ApplicationController
  before_action :authenticate_user!
  def home
      if (user_signed_in?)
          redirect_to :controller => 'jobs'
      end
  end
end
