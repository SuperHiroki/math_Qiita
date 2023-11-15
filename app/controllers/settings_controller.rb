# app/controllers/settings_controller.rb
class SettingsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user
  
    #アカウント設定
    def account
    end
    
    def update_account
        if params[:user][:icon_photo]
          uploaded_file = params[:user][:icon_photo]
          icon_photo_name = upload_to_s3(uploaded_file)
          params[:user][:icon_photo_name] = icon_photo_name if icon_photo_name
        end
        
        if @user.update(user_params)
          redirect_to settings_account_path, notice: 'Account updated successfully.'
        else
          render :account, status: :unprocessable_entity
        end
    end
      
    def upload_to_s3(uploaded_file)
        s3 = Aws::S3::Resource.new
        obj_key = "user-icon/#{uploaded_file.original_filename}"
        obj = s3.bucket('my-unique-bucket-name-shiroatohiro').object(obj_key)
        obj.upload_file(uploaded_file.path)
        return obj.public_url 
    end

    #プロフィール設定
    def profile
        @profile = @user.profile || @user.build_profile
    end

    def update_profile
      @profile = @user.profile || @user.build_profile
      if @profile.update(profile_params)
        redirect_to settings_profile_path, notice: 'Profile updated successfully.'
      else
        render :profile, status: :unprocessable_entity
      end
    end
  
    #通知設定
    def notification
      @notification = @user.notification || @user.build_notification
    end

    def update_notification
      @notification = @user.notification || @user.build_notification
      if @notification.update(notification_params)
        redirect_to settings_notification_path, notice: 'Notification settings updated successfully.'
      else
        render :notification, status: :unprocessable_entity
      end
    end
  
    private
  
    def set_user
      @user = current_user
    end
  
    def user_params
      params.require(:user).permit(:username, :email, :icon_photo_name, :language)
    end
  
    def profile_params
      params.require(:profile).permit(:name, :public_email, :github, :website, :organization, :location, :introduction, :sns1, :sns2, :sns3, :sns4, :sns5, :sns6)
    end
  
    def notification_params
      params.require(:notification).permit(:email1, :email2, :email3, :email4, :email5, :email6, :like, :comment, :answer)
    end
end
  