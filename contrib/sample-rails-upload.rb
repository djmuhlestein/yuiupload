# A Rails back end for yui rich text editor's image uploader
# http://allmybrain.com/2009/07/01/example-image-upload-with-yui-rich-text-editor-270/
# In this example, I created a model to store the images, with paperclip, on Amazon s3
# If you aren't familiar with Paperclip, I think there is a Railscast about it
#
# contributed by Josh Cheek


# =====  THE MIGRATION  =====
class CreateUploadedImages < ActiveRecord::Migration
  def self.up
    create_table :uploaded_images do |t|
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at

      t.timestamps
    end
  end

  def self.down
    drop_table :uploaded_images
  end
end



# =====  THE MODEL  =====
class UploadedImage < ActiveRecord::Base
  has_attached_file :image, :storage => :s3 , :s3_credentials => "#{RAILS_ROOT}/config/s3.yml", :path => "/:class/:id.:extension"
end




# =====  THE ROUTE  =====
# Okay, here I put it under my pages controller, because pages are the only thing that uses this
# Later on, if this doesn't remain true, I'll move it into its own controller with its own route.
# Note: I have to do it with connect, b/c of some other plugins we have installed, but you can
# probably get away with making it a collection
map.connect '/pages/image_upload' , :method => :post , :controller => :pages , :action => 'image_upload'



# =====  THE CONTROLLER  =====
# Again, if you find yourself using this for more than just pages
# then it should probably go in its own controller.
class PagesController < ApplicationController

  def image_upload
    image = UploadedImage.new 'image' => params[:image]
    if image.save
      render :inline => "{status:'UPLOADED', image_url:'#{image.image.url}'}" , :type => :json
    else
      logger.error "Could not upload the Page Image. #{image.errors.inspect}"
      render :inline => "{status:'ERROR'}" , :type => :json
    end
  end


