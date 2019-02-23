class Relationship
  include Mongoid::Document
  belongs_to :follower, class_name: "User", inverse_of: :followers
  belongs_to :followed, class_name: "User", inverse_of: :following
  #has_and_belongs_to_many :users
  
  field :follower_id, type: String
  field :followed_id, type: String
  index({ follower_id: 1 }, { unique: true, name: "follower_id_index" })
  index({ followed_id: 1 }, { unique: true, name: "followed_id_index" })
  index({ follower_id: 1, followed_id: 1 }, { unique: true })
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true


end
