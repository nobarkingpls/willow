xml.instruct!

xml.tag!("mdmec:CoreMetadata",
  "xmlns:md" => "http://www.movielabs.com/schema/md/v2.7/md",
  "xmlns:xsi" => "http://www.w3.org/2001/XMLSchema-instance",
  "xmlns:mdmec" => "http://www.movielabs.com/schema/mdmec/v2.7",
  "xsi:schemaLocation" => "http://www.movielabs.com/schema/mdmec/v2.7 mdmec-v2.7.1.xsd"
) do
  xml.tag!("mdmec:Basic", "ContentID" => "md:cid:org:outtv:#{@movie.title}") do
    xml.tag!("md:LocalizedInfo", "language" => "en", "default" => "true") do
      xml.tag!("md:TitleDisplayUnlimited", @movie.title)
      @movie.genres.each do |genre|
        xml.tag!("md:Genre", genre.name)
      end
    end
    @movie.actors.each_with_index do |actor, index|
      xml.tag!("md:People") do
        xml.tag!("md:Job") do
          xml.tag!("JobFunction", "Actor")
          index += 1
          xml.tag!("BillingBlockOrder", index)
        end
        xml.tag!("md:Name") do
          xml.tag!("md:DisplayName", actor.name)
        end
      end
    end
    # add more nested content here if needed
  end
end
