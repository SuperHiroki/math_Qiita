class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :drafts] 
  before_action :set_post, only: [:edit, :update, :destroy, :show]
  before_action :authorize_user!, only: [:edit, :update, :destroy]

  #記事作成
  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    tag_names = params[:post][:tags].split(',').map(&:strip).uniq
    tags = tag_names.map do |name|
      Tag.find_or_create_by(name: name)
    end
    @post.tags = tags  
  
    if params[:commit] == 'Save Draft' || params[:commit] == 'Save'
      @post.draft = true
    else
      @post.draft = false
    end
  
    if @post.save
      if params[:commit] == 'Save'
        redirect_to "/#{@post.user.username}/items/#{@post.link}/edit", allow_other_host: true, notice: "Saved successfully."
      else
        redirect_to "/#{@post.user.username}/items/#{@post.link}/", allow_other_host: true, notice: 'Article created successfully.'
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  #記事の編集
  def edit
    @post = Post.includes(:user).find_by!(link: params[:link])
    if @post.user == current_user
      render :edit
    else
      redirect_to root_path, alert: "You are not allowed to access this page."
    end
  end
  
  def update
    @post = Post.includes(:user).find_by!(link: params[:link])
    
    if params[:commit] == 'Save Draft' || params[:commit] == 'Save'
      @post.draft = true
    else
      @post.draft = false
    end

    if @post.update(post_params)
      if params[:commit] == 'Save'
        redirect_to "/#{params[:username]}/items/#{params[:link]}/edit", notice: "Saved successfully."
      else
        redirect_to "/#{params[:username]}/items/#{params[:link]}/", notice: "Article updated successfully."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  #記事の削除
  def destroy
    if @post.destroy
      if @post.post_type == "article"
        redirect_to "/articles/", notice: "Article was successfully deleted."
      elsif @post.post_type == "question"
        redirect_to "/questions/", notice: "Article was successfully deleted."
      end
    else
      redirect_to "/#{params[:username]}/items/#{params[:link]}/", alert: "Article could not be deleted."
    end
  end

  #記事の1ページ
  def show
    @post = Post.includes(:user, :comments, :likes).find_by!(link: params[:link])
    @comments = @post.comments # 記事に紐づくコメント
    @likes_count = @post.likes.count # いいねの数
    @likes_count_for_comments = Comment.joins(:likes).where(post_id: @post.id).group(:id).count
  
    if @post.draft && @post.user != current_user
      redirect_to root_path, alert: "You are not allowed to view this draft."
    end
  end

  #記事の一覧を表示する
  def articles
    @q = Post.ransack(params[:q]) 
    @posts = posts('article', false)
  end

  def questions
    @q = Post.ransack(params[:q]) 
    @posts = posts('question', false)
  end

  def drafts
    @q = Post.ransack(params[:q]) 
    @posts = posts(['article', 'question'], true).where(user: current_user)
  end

  def posts(post_type, draft)
    search_params = params[:q] || {}
    sort_option = search_params[:s] || 'created_at_desc'
    posts_scope = Post.includes(:user, :tags).where(post_type: post_type, draft: draft)
    if search_params[:title_or_content_or_tags_name_or_user_username_cont_all].present?
      keywords = search_params[:title_or_content_or_tags_name_or_user_username_cont_all].split(' ')
      keywords.each do |keyword|
        posts_scope = Post.where(id: posts_scope.select(:id)).eager_load(:tags).ransack({
          title_or_content_or_tags_name_or_user_username_cont_any: keyword
        }).result(distinct: true)
      end
    else
      logger.debug "VVVVVVVVVVVVVVVVVVVVVVVVVVVVVVVV"
    end
    posts_with_all_tags = Post.where(id: posts_scope.select(:id)).eager_load(:tags)
    posts_with_all_tags.filter_sort(sort_option).page(params[:page]).per(6)
  end

  private

  def post_params
    params.require(:post).permit(:title, :content, :post_type)
  end

  def set_post
    @post = Post.includes(:user).find_by!(link: params[:link])
  end

  def authorize_user!
    redirect_to root_path, alert: "You are not allowed to perform this action." unless @post.user == current_user
  end
end
