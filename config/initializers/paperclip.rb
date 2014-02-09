
Paperclip::Attachment.default_options[:url] = "/system/:class/:attachment/:id/:style_:hash.:extension"
Paperclip::Attachment.default_options[:hash_data] = ":class/:attachment/:id/:style"
Paperclip::Attachment.default_options[:hash_secret] = "1234567890"