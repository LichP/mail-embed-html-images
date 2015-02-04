require "./lib/mail/embed-html-images/version"

Gem::Specification.new do |s|
  s.name = "mail-embed-html-images"
  s.version = Mail::EmbedHTMLImages::VERSION
  s.summary = %{Extends Mail to provide a mechanism for converting external image sources to embedded attachments.}
  s.description = %Q{Extends Mail to provide a mechanism for converting external image sources to embedded attachments.}
  s.authors = ["Phil Stewart"]
  s.email = ["phil.stewart@lichp.co.uk"]
  s.homepage = "https://github.com/lichp/mail-embed-html-images"
  s.license = "MIT"

  s.files = Dir[
    "lib/**/*.rb",
    "README*",
    "LICENSE"
  ]

  s.add_runtime_dependency "mail", ">= 2.6"
end
