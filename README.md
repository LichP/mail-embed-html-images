mail-embed-html-images
======================

Extends [Mail](https://github.com/mikel/mail) to provide a mechanism for
converting external image sources to embedded attachments.

Usage
-----

```ruby
require 'mail'
require 'mail/embed-html-images'

mail = Mail.new do
  from       'sender@example.com'
  to         'recipient@example.com''
  subject    'This is a test email'
  html_part  File.read('body.html')
end

mail.embed_html_images
mail.deliver
```

The `embed_html_images` method looks for image tags with http[s] sources,
downloads the image from the src attribute, adds it as an attachment, and
replaces the original src attribute with a cid reference to the attachment.

It keeps track of downloaded files so if you have two images with the same
source it will only download and attach tha image once and ref the same
attachment from both images.

If you change the html_part, then you will need to re-run
`embed_html_images`.  This will download any new images found, and remove
any attached images which are no longer required.

That is all.
