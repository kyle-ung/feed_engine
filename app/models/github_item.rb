class GithubItem < ActiveRecord::Base
  include Streamable
  attr_accessible :gist, :event_id

  validates_presence_of :event_id


  belongs_to :user 

  has_many :stream_items, :as => :streamable

  serialize :gist
end
