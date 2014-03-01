class Poster
	include Mongoid::Document

	belongs_to :user
	# has_many :tags
	has_and_belongs_to_many :tags

	field :title, type: String
	field :content, type: String
	field :create_at, type: Integer
	field :update_at, type: Integer
	field :user_id, type: String

	index user_id: 1
	validates :user_id, :presence => true
	validates :title, :presence => true


    # before_save do
        # self.activity.item.categories.each do |c|
        #     self.tags << c
        # end
    # end

	paginates_per 5

end

