class Poster
	include Mongoid::Document
	include Mongoid::Timestamps

	belongs_to :user
	# has_many :tags
	has_and_belongs_to_many :tags

	field :title, type: String
	field :content, type: String
	# field :create_at, type: Integer
	# field :update_at, type: Integer
	field :user_id, type: String

	index user_id: 1
	validates :user_id, :presence => true
	validates :title, :presence => true

    # 数据验证（validation）功能:  长度限制
	validates :title, length: { maximum: 40}
	validates :content, length: { maximum: 40}

    # before_save do
        # self.activity.item.categories.each do |c|
        #     self.tags << c
        # end
    # end

	paginates_per 5

end

