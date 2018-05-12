Spree::HomeController.class_eval do

helper 'spree/products'

  def index
    #Spree::Slide.all.each do |slide|
    #  slide.product_id = nil
     # slide.save
    #end
	  @searcher = build_searcher(params.merge(include_images: true))
	  @taxon = Spree::Taxon.find_by_name("Featured Products") if @searcher.properties[:taxon].nil?
	  @searcher.properties[:taxon] = @taxon  
      @products = @searcher.retrieve_products.limit(20)
      @products = @products.includes(:possible_promotions) if @products.respond_to?(:includes)
      @taxonomies = Spree::Taxonomy.includes(root: :children)
  end

  def sale
      @products = Product.joins(:variants_including_master).where('spree_variants.sale_price is not null').uniq
  end


end