# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  has_many :active_mentions, class_name: 'Mention', inverse_of: 'mentioning', foreign_key: :mentioning_id, dependent: :destroy
  has_many :passive_mentions, class_name: 'Mention', inverse_of: 'mentioned', foreign_key: :mentioned_id, dependent: :destroy

  has_many :mentioning_reports, through: :active_mentions, source: :mentioned
  has_many :mentioned_reports, through: :passive_mentions, source: :mentioning

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
