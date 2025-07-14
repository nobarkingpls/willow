class GenerateMd5ForSccJob < ApplicationJob
  queue_as :default

  # def perform(class_name, record_id)
  #   record = class_name.constantize.find_by(id: record_id)
  #   return unless record&.send(:scc)&.attached?

  #   md5 = Digest::MD5.hexdigest(record.send(:scc).download)
  #   record.update_column(:scc_md5, md5)
  # end

  def perform(record)
    return unless record&.send(:scc)&.attached?

    md5 = Digest::MD5.hexdigest(record.send(:scc).download)
    record.update_column(:scc_md5, md5)
  end
end
