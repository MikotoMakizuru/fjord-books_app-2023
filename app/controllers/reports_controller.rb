# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentioned_reports = @report.mentioned_reports
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      create_mentions
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      @report.mentioning_reports.each { |mentioned_report_id| @report.mentioning_reports.delete(mentioned_report_id) }
      create_mentions
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def create_mentions
    mentioned_report_ids = find_mentioned_report_ids

    mentioned_report_ids.each do |mentioned_report_id|
      unless Mention.exists?(mentioning_id: @report.id, mentioned_id: mentioned_report_id)
        Mention.create(mentioning_id: @report.id, mentioned_id: mentioned_report_id)
      end
    end
  end

  MENTION_PATH_REGEX = %r{/reports/(\d+)}

  def find_mentioned_report_ids
    report_ids = URI.extract(@report.content, ['http']).map do |url|
      path = URI.parse(url).path
      path.match(MENTION_PATH_REGEX)[1]&.to_i
    end
    report_ids.compact.uniq
  end
end
