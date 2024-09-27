module AuthenticationHelpers
    def sign_in(user)
      session[:user_id] = user.id
    end
  end
  
  RSpec.configure do |config|
    config.include AuthenticationHelpers, type: :controller
  end
  