功能：
实现了用户的CRUD操作，其中用户信息包含一个图片类型的附件。

附件上传功能使用了paperclip模块实现

在rails中集成了sinatra

sinatra主要提供Api级别的服务，在本案例中，create user部分同时实现了sinatra api方式的调用（通过ajax请求调用api，没有实现图片上传功能）。


paperclip命名方式修改：
User模型：
:path => ":rails_root/public/system/:class/:attachement/:id/:basename_:style.:extension",
:url => "/system/:class/:attachement/:id/:basename_:style.:extension",
这里面有个小问题，basename是指上传的文件名称（不包括扩展名），如果是中文，在Linux系统下面会有系统编码问题，比如在shell操作文件路径的时候可能乱码等问题。

所以对于paperclip我们常用以下的方式的命名，并将上传的附件保存起来：
Paperclip::Attachment.default_options[:url] = "/system/:class/:attachment/:id/:style_:hash.:extension"
Paperclip::Attachment.default_options[:hash_data] = ":class/:attachment/:id/:style"
Paperclip::Attachment.default_options[:hash_secret] = "1234567890"

这是个全局的文件，保存在config/initializers/paperclip.rb这里。


日志打印方式修改：
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
