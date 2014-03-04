class Tag
  include Mongoid::Document

  has_and_belongs_to_many :posters

  field :name, type: String
  
  validates :name, :presence => true, :uniqueness => true
end
