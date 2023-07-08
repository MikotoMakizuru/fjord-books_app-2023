# frozen_string_literal: true

class ReportsController < ApplicationController
  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comments = @report.comments
    @comment = Comment.new
  end

  def new
    @report = Report.new
  end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      redirect_to @report, notice: '日報を保存しました'
    else
      render :new
    end
  end

  def edit
    @report = current_user.reports.find(params[:id])
  end

  def update
    @report = Report.find(params[:id])

    if @report.update(report_params)
      redirect_to @report, notice: '日報を保存しました'
    else
      render :edit
    end
  end

  def destroy
    @report = current_user.reports.find(params[:id])
    @report.destroy

    redirect_to reports_url, notice: '日報を削除しました'
  end

  private

  def report_params
    params.require(:report).permit(:title, :body)
  end
end
