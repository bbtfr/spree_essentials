class Spree::Upload < ::Spree::Asset
  
  attr_accessible :attachment, :alt
  
  default_scope where(:type => "Upload") if table_exists?
  
  validates_attachment_presence :attachment

  has_attached_file :attachment,
    :styles        => Proc.new{ |clip| clip.instance.attachment_sizes },
    :default_style => :medium,
    :url           => "/spree/uploads/:id/:style/:basename.:extension",
    :path          => ":rails_root/public/spree/uploads/:id/:style/:basename.:extension"
  
  def image_content?
    attachment_content_type.match(/\/(jpeg|png|gif|tiff|x-photoshop)/)
  end
     
  def attachment_sizes
    hash = {}
    hash.merge!(:mini => '48x48>', :small => '150x150>', :medium => '600x600>', :large => '950x700>') if image_content?
    hash
  end
  
end
