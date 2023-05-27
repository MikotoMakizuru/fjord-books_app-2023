class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :postcode, format: { with: /\A\d{3}[-]?\d{4}\z/, allow_blank: true }
  validates :postcode, format: { without: /\s/, allow_nil: true }
end
