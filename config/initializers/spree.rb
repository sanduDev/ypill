# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# Note: If a preference is set here it will be stored within the cache & database upon initialization.
#       Just removing an entry from this initializer will not make the preference value go away.
#       Instead you must either set a new value or remove entry, clear cache, and remove database entry.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
  # Example:
  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false

  config.admin_interface_logo = '/images/logo.png'
  config.logo = '/images/logo.png'
  config.products_per_page = 8
  Spree::Config[:layout]='/spree/frontend/layouts/spree_application'
   
end

Spree::PrintInvoice::Config.set(logo_path: '/images/logo.png')

Spree.user_class = "Spree::LegacyUser"


Spree::PermittedAttributes.user_attributes.push :referral_code, :affiliate_code, :first_name, :last_name
config = Rails.application.config
config.after_initialize do
  config.spree.promotions.rules << Spree::Promotion::Rules::ReferredPromotionRule
  config.spree.promotions.rules << Spree::Promotion::Rules::AffiliatedPromotionRule

# config.spree.promotions.actions << Spree::Promotion::Actions::RelatedProductDiscount
end

#Rails.application.config.spree.promotions.actions << RelatedProductDiscount


