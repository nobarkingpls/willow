xml.instruct!

xml.tag!("mdmec:CoreMetadata",
  "xmlns:md" => "http://www.movielabs.com/schema/md/v2.7/md",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:mdmec" => "http://www.movielabs.com/schema/mdmec/v2.7",
  "xsi:schemaLocation" => "http://www.movielabs.com/schema/mdmec/v2.7 mdmec-v2.7.1.xsd"
) do
  xml.tag!("mdmec:Basic", "ContentID" => "md:cid:org:outtv:#{@show.generate_apple_id}") do
    xml.tag!("md:LocalizedInfo", "language" => "en", "default" => "true") do
      xml.tag!("md:TitleDisplayUnlimited", "#{@show.title}")
      seasons = @show.seasons
      xml.tag!("md:seasoncountheh", "#{seasons.count}")
      seasons.each do |season|
        xml.tag!("md:seasontestheh", "#{season.generate_apple_id}")
      end
    end
    # add more nested content here if needed
  end
end
