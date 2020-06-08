class User < ApplicationRecord
  has_secure_password
  has_one :user_detail, dependent: :destroy

  validates :name, presence: true,
                    length: { in: 1..255 }

  validates :password, presence: true,
                      length: { in: 8..255 }
end
