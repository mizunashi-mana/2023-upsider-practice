module TaxActions extend ActiveSupport::Concern
  TAX_RATIO = 0.1
  def calculate_tax(target_price_jpy)
    @price_jpy = (target_price_jpy * TAX_RATIO).floor

    {
      tax_ratio: TAX_RATIO,
      tax_price_jpy: @price_jpy
    }
  end
end
