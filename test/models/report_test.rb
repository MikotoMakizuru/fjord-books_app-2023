# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @report_by_alice = reports(:report_by_alice)
    @report_by_bob = reports(:report_by_bob)
    @report_by_carol = reports(:report_by_carol)
  end

  test 'editable?' do
    assert @report_by_alice.editable?(@alice)
    assert_not @report_by_bob.editable?(@alice)
  end

  test 'created_on' do
    assert_equal Time.zone.today, @report_by_alice.created_on
  end

  test 'seve_mentions' do
    # 言及なし
    report = {
      user: users(:alice),
      title: 'alice title',
      content: 'alice content'
    }
    report = Report.create(report)
    assert_equal [], report.mentioning_reports

    # 言及あり
    report = {
      user: users(:alice),
      title: 'alice title',
      content: "hoge http://localhost:3000/reports/#{@report_by_bob.id}"
    }
    report = Report.create(report)
    assert_equal [@report_by_bob], report.mentioning_reports

    # 言及するURLを更新
    updated_content = {
      content: "fuga http://localhost:3000/reports/#{@report_by_carol.id}"
    }
    report.update(updated_content)
    assert_equal [@report_by_bob, @report_by_carol], report.mentioning_reports

    # 言及するURLを削除して更新
    deleted_mention_content = {
      content: 'Dleted mention'
    }
    report.update(deleted_mention_content)
    assert_equal [], report.reload.mentioning_reports
  end
end
