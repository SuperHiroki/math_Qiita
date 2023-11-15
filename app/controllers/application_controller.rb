class ApplicationController < ActionController::Base
    protected

    def after_sign_in_path_for(resource)
      if defined?(Admin) && resource.is_a?(Admin)
        admin_dashboard_path # 管理者用ダッシュボードにリダイレクト
      else
        root_path 
      end
    end

    def after_sign_out_path_for(resource)
      root_path 
    end
end
