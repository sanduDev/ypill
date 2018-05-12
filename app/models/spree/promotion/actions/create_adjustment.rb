module Spree
  class Promotion
    module Actions
      class CreateAdjustment < PromotionAction
        include Spree::CalculatedAdjustments
        include Spree::AdjustmentSource

        before_validation -> { self.calculator ||= Calculator::FlatPercentItemTotal.new }

        def perform(options = {})
          order = options[:order]
          create_unique_adjustment(order, order)
        end

        def compute_amount(order)

          com_order = compute(order)
          com_order = 0.0 if com_order.nil?
           
          [(order.item_total + order.ship_total), com_order].min * -1
        end
      end
    end
  end
end
