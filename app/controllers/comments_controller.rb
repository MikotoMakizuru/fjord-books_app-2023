# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: 'コメントを投稿しました！'
    else
      case @commentable
      when Book
        redirect_to book_path(@commentable), status: :unprocessable_entity
      when Report
        redirect_to report_path(@commentable), status: :unprocessable_entity
      end
    end
  end

  def destroy
    Comment.find(params[:id]).destroy

    redirect_to @commentable, notice: 'コメントを削除しました'
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
