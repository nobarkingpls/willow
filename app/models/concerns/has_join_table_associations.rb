module HasJoinTableAssociations
    extend ActiveSupport::Concern

    # example of a named association is a join where the destination model has a 'name' field, like actors, genres
    def update_named_associations(association, names_string)
        return if names_string.blank?
    
        new_names = names_string.split(",").map(&:strip)
        existing_names = send(association).pluck(:name)
    
        names_to_add = new_names - existing_names
        names_to_add.each do |name|
          send(association) << association.to_s.classify.constantize.find_or_create_by(name: name)
        end
    
        names_to_remove = existing_names - new_names
        send(association).where(name: names_to_remove).each do |record|
          send(association).delete(record)
        end
    end

    # example of a named association is a join where the destination model has a country 'code' field, like countries, territories
    def update_country_code_associations(association, codes_string)
        return if codes_string.blank?
    
        new_codes = codes_string.split(",").map(&:strip)
        existing_codes = send(association).pluck(:code)
    
        codes_to_add = new_codes - existing_codes
        codes_to_add.each do |code|
          send(association) << association.to_s.classify.constantize.find_or_create_by(code: code)
        end
    
        codes_to_remove = existing_codes - new_codes
        send(association).where(code: codes_to_remove).each do |record|
          send(association).delete(record)
        end
    end
end