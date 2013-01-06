class Spree::Admin::UploadsController < Spree::Admin::ResourceController
  
	def index
	  render :template => "spree/admin/uploads/#{request.xhr? ? 'picker' : 'index'}", :layout => !request.xhr?
  end

  def create
    @object.attachment = params[:file] if params[:file]
    invoke_callbacks(:create, :before)
    if @object.save
      invoke_callbacks(:create, :after)
      flash[:success] = flash_message_for(@object, :successfully_created)
      respond_with(@object) do |format|
        format.html { redirect_to location_after_save }
        format.js   { render :layout => false }
        format.json { render :json => { 
          filelink: @object.attachment.url(:original), 
          filename: @object.attachment.original_filename,
        } }
      end
    else
      invoke_callbacks(:create, :fails)
      respond_with(@object)
    end
  end
  
  private
  
    def collection
      params[:q] ||= {}
      params[:q][:sort] ||= "created_at.desc"
      @search = Spree::Upload.search(params[:q])
      @collection = @search.result.page(params[:page]).per(Spree::Config[:orders_per_page])
    end

end
