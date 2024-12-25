class Movie < ApplicationRecord
    has_and_belongs_to_many :genres
    has_many :rights, dependent: :destroy
    accepts_nested_attributes_for :rights, allow_destroy: true, reject_if: :all_blank
end
