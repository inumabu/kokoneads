class ToolHistory < ApplicationRecord
  belongs_to :user
  validates :slug, presence: true
  validates :input_preview, length: { maximum: 500 }, allow_blank: true
end
