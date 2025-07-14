xml.instruct!

xml.tag!("package",
  "xmlns" => "http://apple.com/itunes/importer",
  "version" => "subscriptionvideo5.0",
) do
  xml.tag!("comments")
  xml.tag!("language", "en")
  xml.tag!("provider", "OUTtvNetworkInc")
  xml.tag!("video") do
    xml.tag!("umc_catalog_id", "com.outtv.svod.catalog")
    xml.tag!("umc_content_id", @movie.generate_apple_id)
    xml.tag!("umc_variant_id", "1")
    xml.tag!("title", @movie.title)
    xml.tag!("original_spoken_locale", "en") # should prob make an original language field
    xml.tag!("assets") do
      xml.tag!("asset", "type" => "full") do
        # here's where the source and captions data would go
        # source has crop information and photo sens
        # for now ill add it all like this, but it is supposed to read info from db
        xml.tag!("data_file", "role" => "source") do
          xml.tag!("locale", "name" => "en")
          xml.tag!("file_name", "com.outtv.svod.catalog_#{@movie.generate_apple_id}_1.mov")
          xml.tag!("size", "")
          if @movie.photosensitivity
            xml.tag!("attribute", { "name" => "photosensitive_epilepsy_risk" }, "true")
          end
          xml.tag!("caption md5 heh", @movie.scc_md5)
          # etcetera :>
        end
      end
    end
    # add more nested content here if needed
  end
end
