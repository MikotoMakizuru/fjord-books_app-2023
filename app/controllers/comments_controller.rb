# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :set_commentable, only: %i[create destroy]

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_post', name: Comment.model_name.human)
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
    current_user.comments.find(params[:id]).destroy

    redirect_to @commentable, notice: t('controllers.common.notice_destroy', name: Comment.model_name.human)
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
