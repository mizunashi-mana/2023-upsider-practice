class InvoicesController < ApplicationController
  include TaxActions
  include TransactionFeeActions
  include PaymentActions

  def new
    @user = session_user_authentication_with_finding
    if @user.nil?
      return
    end

    @issued_customer_id = params.required(:issued_customer_id)
    @issued_date = params.required(:issued_date)
    @payment_due_date = params.required(:payment_due_date)
    @claimed_amount_jpy = params.required(:claimed_amount_jpy).to_i

    @issued_customer = Customer.find_by(
      id: @issued_customer_id,
      target_organization_id: @user.organization_id,
    )
    if @issued_customer.nil?
      return render status: :bad_request
    end

    @authority = user_authority_on_customer(
      @user,
      @issued_customer.id,
    )
    if !@authority[:invoices_new]
      return render status: :bad_request
    end

    @transaction_fee = calculate_transaction_fee(@claimed_amount_jpy)
    @transaction_fee_tax = calculate_tax(@transaction_fee[:fee_price_jpy])
    @payment_amount_jpy = @claimed_amount_jpy +
      @transaction_fee[:fee_price_jpy] +
      @transaction_fee_tax[:tax_price_jpy]
    @invoice = Invoice.new(
      issued_customer: @issued_customer,
      status: :unprocessed,
      issued_date: @issued_date,
      payment_due_date: @payment_due_date,
      payment_amount_jpy: @payment_amount_jpy,
      claimed_amount_jpy: @claimed_amount_jpy,
      transaction_fee_jpy: @transaction_fee[:fee_price_jpy],
      transaction_fee_ratio: @transaction_fee[:fee_ratio],
      transaction_fee_tax_jpy: @transaction_fee_tax[:tax_price_jpy],
      transaction_fee_tax_ratio: @transaction_fee_tax[:tax_ratio],
    )

    @current_date = Date.today
    if !validate_payable_due_date(@invoice.payment_due_date, @current_date)
      return render status: :bad_request
    end

    if !@invoice.save
      logger.warn "Failed to save invoice."
      logger.debug @invoice.errors.inspect
      return render status: :internal_server_error
    end

    render json: {
      invoice_id: @invoice.id,
    }
  end

  def list
    @user = session_user_authentication_with_finding
    if @user.nil?
      return
    end

    @payment_due_date_begin = params.required(:payment_due_date_begin).to_date
    @payment_due_date_end = params.required(:payment_due_date_end).to_date

    @authority = user_authority_on_organization(@user)
    if @authority[:invoices_list]
      @customers = Customer.where(target_organization_id: @user.organization_id)
      @invoices = Invoice.joins(:issued_customer).where(
        issued_customer: {
          target_organization_id: @user.organization_id,
        },
        invoices: {
          payment_due_date: @payment_due_date_begin..@payment_due_date_end,
        },
      )
    else
      # In the non-admin case, filter customers just to be sure.
      @customers = Customer.joins(:user_authority_on_customers).where(
        customers: {
          target_organization_id: @user.organization_id
        }
      )
      @invoices = Invoice.joins(:issued_customer).joins(issued_customer: :user_authority_on_customers).where(
        issued_customer: {
          target_organization_id: @user.organization_id,
        },
        invoices: {
          payment_due_date: @payment_due_date_begin..@payment_due_date_end,
        },
        user_authority_on_customers: {
          user_id: @user.id,
        },
      )
    end

    @customer_id_to_customer = @customers.to_h { |x| [x.id, x] }
    @viewable_invoices = @invoices.select do |invoice|
      if @authority[:invoices_list]
        true
      else
        @authority_on_customer = @authority[:by_customer_ids][invoice.issued_customer_id]
        !@authority_on_customer.nil? && @authority_on_customer[:invoices_list]
      end
    end

    render json: {
      invoices: @viewable_invoices.map do |invoice|
        @issued_customer = @customer_id_to_customer[invoice.issued_customer_id]
        {
          id: invoice.id,
          issued_customer: {
            id: @issued_customer.id,
            name: @issued_customer.name,
          },
          status: invoice.public_status,
          issued_date: invoice.issued_date,
          payment_due_date: invoice.payment_due_date,
          payment_amount_jpy: invoice.payment_amount_jpy,
        }
      end
    }
  end
end
