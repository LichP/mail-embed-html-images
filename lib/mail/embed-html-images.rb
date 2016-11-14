require 'mail'
require 'digest/sha1'
require 'net/http'

module Mail
  module EmbedHTMLImages
    MIME_TO_EXTENSION = {
      'image/png'  => 'png',
      'image/jpeg' => 'jpg',
      'image/gif'  => 'gif',
    }

    def embed_html_images
      @_embedded_images ||= {}
      current_images = {}

      # Don't do anything if we don't have an html part
      return unless html_part

      # Find all img tags in the html part
      new_html = html_part.body.to_s.gsub(/<img (.*?)src=((?<![\\])['"])(http(?:.(?!(?<![\\])\2))*.?)\2([^>]*)>/) do |match_string|
        img_src_original = $3
        img_src_hash = Digest::SHA1.hexdigest img_src_original

        # Check to see whether or not we already have this image: if not, attempt to attach it
        if !@_embedded_images[img_src_hash]
          response = Net::HTTP.get_response(URI(img_src_original))

          # If we were successful retrieving the image, attach it
          if response.kind_of? Net::HTTPSuccess
            attachment_filename = img_src_hash + '.' + MIME_TO_EXTENSION[response["content-type"]]
            add_file filename: attachment_filename, content: response.body
            @_embedded_images[img_src_hash] = attachment_filename
          end
        end

        # If we already have this image or have successfully attached it, update the matched img element
        if @_embedded_images[img_src_hash]
          current_images[img_src_hash] = @_embedded_images[img_src_hash]

          attached_image = attachments[@_embedded_images[img_src_hash]]

          # Create new src using content id of attachment
          img_src_new = "cid:#{attached_image.cid}"

          # Return substitute with new src
          "<img #{$1}src=\"#{img_src_new}\"#{$4}>"
        else
          # Attachment couldn't be attached, leave img element unchanged
          match_string
        end
      end

      # Detach any images that are no longer needed
      @_embedded_images.each do |hash, filename|
        if !current_images[hash]
          self.parts.delete_if { |p| p.filename == filename }
        end
      end
      @_embedded_images = current_images

      html_part.body = new_html
    end
  end

  class Message
    include EmbedHTMLImages
  end
end
