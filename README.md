功能：
实现了用户的CRUD操作，其中用户信息包含一个图片类型的附件。

附件上传功能使用了paperclip模块实现

在rails中集成了sinatra

sinatra主要提供Api级别的服务，在本案例中，create user部分同时实现了sinatra api方式的调用（通过ajax请求调用api，没有实现图片上传功能）。


 ============ 2014/02/09 START===============

### paperclip命名方式修改：

User模型：

	:path => ":rails_root/public/system/:class/:attachement/:id/:basename_:style.:extension",
	:url => "/system/:class/:attachement/:id/:basename_:style.:extension",

这里面有个小问题，basename是指上传的文件名称（不包括扩展名），如果是中文，在Linux系统下面会有系统编码问题，
比如在shell操作文件路径的时候可能乱码等问题。

所以对于paperclip我们常用以下的方式的命名，并将上传的附件保存起来：

	Paperclip::Attachment.default_options[:url] = "/system/:class/:attachment/:id/:style_:hash.:extension"
	Paperclip::Attachment.default_options[:hash_data] = ":class/:attachment/:id/:style"
	Paperclip::Attachment.default_options[:hash_secret] = "1234567890"

这是个全局的文件，保存在config/initializers/paperclip.rb这里。


### 日志打印方式修改：

日志打印一般不用print，用Rails.logger.info(error|debug|fatal等)
日志打印到以下文件：

	开发环境：logs/development.log
	测试环境：logs/test.log
	生产环境：logs/production.log

具体的可以在development.rb文件中配置：

1. config.log_level 定义 Rails 日志的冗长程度. 这个选项默认为 :debug 并对所有模式有效,除了生产模式. 生产模式默认为:info

	例：config.log_level = :warn      # 只打印warn以上的日志

2. config.file_parameters 用于过滤掉不想被显示在日志里的参数, 比如密码和信用卡号码.

	例：config.filter_parameters += [:password]   # 日志中不显示密码

......

 ============= 2014/02/09 END===============



* 基于之前的rails项目，加入mongoid库. 
	* 请学习官网的文档：[http://mongoid.org/en/mongoid/index.html]
	* 建立mongoid的配置文件（确保有可用的mongodb数据库，或者安装一个到本机），bundle exec rails g mongoid:config
	* 通过mongoid自带的generator建立一个Poster模型，bundle exec rails g mongoid:model model_name

* Poster是一个帖子的模型，每个用户都可以发很多帖子
	* 请完善帖子模型的各个字段，比如：标题，内容，创建时间，修改时间等
	* 请建立用户和帖子两个模型的关联关系，一个用户有多个帖子，每个帖子只属于同一个用户。

* 实现一个rails的poster controller
	* 实现index、new、create、update、delete等方法
	* 在user controller里面，实现根据某个用户id查找他的所有帖子的API

* 加入kaminari这个库到项目中
* 
	* http://chaoskeh.com/blog/intro-to-kaminari.html (分页插件的用法)
	* 在user controller里面，根据某个用户id搜索帖子的API中，实现分页，比如URI可能是：/users/123/posters?per=10&page=3

* 再建立一个mongoid模型：Tag，标签
	* 标签是poster的特征，比如一个poster可能有以下标签：美食，杭州，昂贵，虾仁等
	* 这个模型和poster模型的关系是多对多，一个poster有多个一个标签，一个标签可以有多个poster。
	* 实现一个rails的tag controller
	* 在poster controller里面，可以做到对某个poster打标签
	* 在tag controller里面，可以根据某个tag把所有的poster搜索出来


