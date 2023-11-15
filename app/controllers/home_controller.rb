class HomeController < ApplicationController
  
  def index
    if current_user
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.username}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.email}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.encrypted_password}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.language}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.icon_photo_name}"
    else
      logger.debug "BBBBBBBBBBBBBBBBBBBBB"
    end
  end

  private

end
