module Spree
  class TaxonsController < Spree::StoreController
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
    helper 'spree/products'

    respond_to :html

    def show
      @taxon = Taxon.friendly.find(params[:id])
      return unless @taxon

      @searcher = build_searcher(params.merge(taxon: @taxon.id, include_images: true))

      sorting_scope = params[:order].try(:to_sym) || :ascend_by_updated_at
      
      @taxonomies = Spree::Taxonomy.includes(root: :children)

      @searcher.retrieve_products.send(sorting_scope)

      @products = @searcher.retrieve_products

       
     
      @curr_page = params[:page] || 1
      @products_per_page = Spree::Config.products_per_page

      @start_no = @curr_page == 1 ? 1 : ((@curr_page.to_i-1)*@products_per_page)+1

      @end_no = @products.length

      if @curr_page.to_i > 1 
         @end_no = ( (@curr_page.to_i-1)*@products_per_page) + @end_no
      end


     # @end_no = @product_count <= @product_count ? @product_count : @products.length+(@curr_page.to_i-1)*@products_per_page

    end

    private

    def accurate_title
      @taxon.try(:seo_title) || super
    end
  end
end
