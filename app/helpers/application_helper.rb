module ApplicationHelper

	 def taxons_tree_1(root_taxon, current_taxon, max_level = 1)
	      return '' if max_level < 1 || root_taxon.leaf?
	      content_tag :div, class: 'list-group' do
	        taxons = root_taxon.children.map do |taxon|
	          css_class = (current_taxon && current_taxon.self_and_ancestors.include?(taxon)) ? 'list-group-item active' : 'list-group-item'
	       		#taxon.name
	          link_to( raw(image_tag(taxon.icon(:normal) ).gsub('"',"'")) + raw("<span>#{taxon.name}</span>"), seo_url(taxon), class: css_class) + taxons_tree(taxon, current_taxon, max_level - 1)
	        end
	        safe_join(taxons, "_ /n")
	       # taxons
	      end
	end


	def load_cms_pages
		Spree::Page.where(render_layout_as_partial: false, visible:true, show_in_header:true).order(position: "ASC")
	end

	def load_partial slug
		#.visible!.render_layout_as_partial
		Spree::Page.find_by_slug(slug)
	end

	def products_count texo_id
		 Spree::Product.in_taxons(texo_id).count
	end

	def child_texts texto_id

		Spree::Taxon.where(parent_id: texto_id).order(position: :ASC).order(name: :ASC)
		
	end

	def reward_points product
		points = 0
		return points if product.nil?
		 minimum_price = Spree::Config.min_amount_required_to_get_loyalty_points  
         per_unit_points = Spree::Config.loyalty_points_awarding_unit  

         if product.price > 0 && minimum_price > 0 && product.price >=  minimum_price && per_unit_points > 0
         	points = product.price*per_unit_points
         end
         return points
	end


	def to_range range
			r = range.split("..")
		if r.size == 2
			{ start: r[0].to_i, end: r[1].to_i  }
		else
			r = range.split("...")
			if r.size == 2
				{ start: r[0].to_i, end: r[1].to_i  }
			end
		end
		
	end

end



