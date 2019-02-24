class TextMessage < ApplicationRecord
  validates :content, presence: true
  validates :content, uniqueness: true
end
