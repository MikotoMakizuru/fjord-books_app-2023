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
    @report_by_alice.created_at = '1993-02-24'.in_time_zone
    assert_equal '1993-02-24'.to_date, @report_by_alice.created_on
  end

  test 'seve_mentions' do
    # 言及なし
    report = @alice.reports.create!(title: 'アリスの日報です', content: 'アリスです。日報を書きました。')
    assert_equal [], report.mentioning_reports

    # 言及あり
    report = @alice.reports.create!(title: 'アリスの日報です', content: "参考記事:hoge http://localhost:3000/reports/#{@report_by_bob.id}")
    assert_equal [@report_by_bob], report.mentioning_reports

    # 言及するURLを更新
    report.update!(content: "参考記事:http://localhost:3000/reports/#{@report_by_carol.id} (編集済)")
    assert_equal [@report_by_bob, @report_by_carol].sort, report.mentioning_reports.sort

    # 言及するURLを削除して更新
    deleted_mention_content = {
      content: 'Deleted mention'
    }
    report.update(deleted_mention_content)
    assert_equal [], report.reload.mentioning_reports
  end
end
