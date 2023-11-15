class HelloController < ApplicationController
  def index
    puts "HHHHHHHHHHHHHHHHHHHHHHHHHHHH new"
    pp "HHHHHHHHHHHHHHHHHHHHHHHHHHHH new"
    logger.debug "HHHHHHHHHHHHHHHHHHHHHHHHHHHH new"
    @hello = "Hello World vvv"

    
    if current_user
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.username}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.email}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.encrypted_password}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.language}"
      logger.debug "AAAAAAAAAAAAAAAAAAAAAA #{current_user.icon_photo_name}"
    else
      logger.debug "BBBBBBBBBBBBBBBBBBBBB"
    end

    render template: "hello/index"

  end




end