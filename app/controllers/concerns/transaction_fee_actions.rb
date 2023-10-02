module TransactionFeeActions extend ActiveSupport::Concern
  FEE_RATIO = 0.04
  def calculate_transaction_fee(transaction_target_price_jpy)
    @price_jpy = (transaction_target_price_jpy * FEE_RATIO).floor

    {
      fee_ratio: FEE_RATIO,
      fee_price_jpy: @price_jpy
    }
  end
end
