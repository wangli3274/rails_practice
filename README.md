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

