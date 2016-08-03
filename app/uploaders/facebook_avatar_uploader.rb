# encoding: utf-8

class FacebookAvatarUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  process convert: 'png'

  version :standard do
    process resize_to_fill: [50, 50, :north]
  end

end
