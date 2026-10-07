class SavedTool < ApplicationRecord
  belongs_to :user
  validates :slug, presence: true, uniqueness: { scope: :user_id }
end
