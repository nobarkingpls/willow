class ActorsShow < ApplicationRecord
    belongs_to :show
    belongs_to :actor
  
    validates_uniqueness_of :show_id, scope: :actor_id
  end
  