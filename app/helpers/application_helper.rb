module ApplicationHelper
    def flash_class(key)
        case key
        when 'notice'
          'bg-blue-500' # 青色の背景
        when 'success'
          'bg-green-500' # 緑色の背景
        when 'error'
          'bg-red-500' # 赤色の背景
        when 'alert'
          'bg-yellow-500' # 黄色の背景
        else
          'bg-gray-500' # デフォルトは灰色の背景
        end
    end
end
