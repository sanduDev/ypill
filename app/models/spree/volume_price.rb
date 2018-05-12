class Spree::VolumePrice < ActiveRecord::Base
  belongs_to :variant, touch: true
  belongs_to :volume_price_model, touch: true
  belongs_to :spree_role, class_name: 'Spree::Role', foreign_key: 'role_id'
  acts_as_list scope: [:variant_id, :volume_price_model_id]

  validates :amount, presence: true
  validates :discount_type,
            presence: true,
            inclusion: {
              in: %w(price dollar percent),
              message: I18n.t(:'activerecord.errors.messages.is_not_a_valid_volume_price_type', value: self)
            }
  validates :range,
            format: {
              with: /\(?[0-9]+(?:\.{2,3}[0-9]+|\+\)?)/,
              message: I18n.t(:'activerecord.errors.messages.must_be_in_format')
            }

  OPEN_ENDED = /\(?[0-9]+\+\)?/

  def include?(quantity)
    if open_ended?
      bound = /\d+/.match(range)[0].to_i
      return quantity >= bound
    else
      to_range(range) === quantity
    end
  end

  # indicates whether or not the range is a true Ruby range or an open ended range with no upper bound
  def open_ended?
    OPEN_ENDED =~ range
  end

  def to_range string
     case string.count('.')
         when 2
             elements = string.split('..')
             return Range.new(elements[0].to_i, elements[1].to_i)
         when 3
             elements = self.split('...')
             return Range.new(elements[0].to_i, elements[1].to_i-1)
         else
             raise ArgumentError.new("Couldn't convert to Range:
              #{string}")
     end
 end


end
