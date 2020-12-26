class TextMessage < ApplicationRecord
  validates :content, presence: true
  validates :content, uniqueness: true

  def message
    { type: 'text', text: content }
  end
end
