  include Spree
  class StaticContentController < StoreController
   # rescue_from ActiveRecord::RecordNotFound, with: :render_404
   #layout "spree_application"
   # layout :determine_layout
    helper 'spree/products'

  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::RespondWith
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Search
  include Spree::Core::ControllerHelpers::Store
  include Spree::Core::ControllerHelpers::StrongParameters

    #layout :determine_layout

    def show
      puts request.path.inspect
      slug = request.path
      if slug == "/"
        slug = "/home"
      end
      
      @page = Spree::Page.find_by_slug(slug)

      # @page = Spree::Page.by_store(current_store).visible.find_by!(slug: slug)
      render "spree/static_content/show"

    end

    private

    def determine_layout
      return @page.layout if @page && @page.layout.present? && !@page.render_layout_as_partial?
      Spree::Config.layout
    end

    def accurate_title
      @page ? (@page.meta_title.present? ? @page.meta_title : @page.title) : nil
    end
  end