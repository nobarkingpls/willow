class Season < ApplicationRecord
  belongs_to :show
  has_many :episodes

  validates :show_id, presence: true

  def show_title
    "#{show.title}"
  end

  def season_title
    "#{show.title} Season #{number}"
  end
end
