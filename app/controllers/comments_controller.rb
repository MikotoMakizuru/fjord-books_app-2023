# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: 'コメントを投稿しました！'
    else
      redirect_to new_book_comment_path, alert: 'コメントの投稿に失敗しました。。orz'
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    redirect_to book_comments_path, notice: 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
