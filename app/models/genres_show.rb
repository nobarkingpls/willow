class GenresShow < ApplicationRecord
  belongs_to :show
  belongs_to :genre

  validates_uniqueness_of :show_id, scope: :genre_id
end
