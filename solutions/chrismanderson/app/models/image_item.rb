class ImageItem < ActiveRecord::Base
  include Streamable
  IMAGE_REGEX = /^https?:\/\/(?:[a-z\-]+\.)+[a-z]{2,6}(?:\/[^\/#?]+)+\.(?:jpg|gif|bmp|png)$/ix
  attr_accessible :comment, :url

  validates_presence_of :url
  validates_length_of :url, :maximum => 2048
  validates_format_of :url, :with => IMAGE_REGEX, :message => 'must be jpg, bmp, png, or gif and start with http/https'
  validates_length_of :comment, :maximum => 256
  has_many :stream_items, :as => :streamable
  has_many :users, :through => :stream_items

  def self.create_from_json(user_id, parsed_json)
    new(:user_id => user_id, :url => parsed_json["image_url"], :comment => parsed_json["comment"])
  end
end
