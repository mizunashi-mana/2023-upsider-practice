require "test_helper"

class InvoicesControllerTest < ActionDispatch::IntegrationTest
  test "should issue new invoice by posting new" do
    login_by_user('user1@example.com')

    next_month_date = Date.today.next_month
    payment_due_date = Date.new(next_month_date.year, next_month_date.month, -1)

    post api_invoices_url,
      params: {
        issued_customer_id: '01HBN3KQHB86KYS3RKT6H696V5',
        issued_date: '2023-08-25',
        payment_due_date: payment_due_date.strftime('%Y%m%d'),
        claimed_amount_jpy: 2123,
      }
    assert_response :success
    @response_body = JSON.parse(@response.body)

    @invoice_id = @response_body['invoice_id']
    @invoice = Invoice.find(@invoice_id)

    assert_equal '01HBN3KQHB86KYS3RKT6H696V5', @invoice.issued_customer_id
    assert_equal 'unprocessed', @invoice.status
    assert_equal Date.new(2023, 8, 25), @invoice.issued_date
    assert_equal payment_due_date, @invoice.payment_due_date
    assert_equal 2123, @invoice.claimed_amount_jpy
    assert_equal 84, @invoice.transaction_fee_jpy
    assert_equal 0.04, @invoice.transaction_fee_ratio
    assert_equal 8, @invoice.transaction_fee_tax_jpy
    assert_equal 0.1, @invoice.transaction_fee_tax_ratio
    assert_equal 2215, @invoice.payment_amount_jpy
  end

  test "should reject members without permission by posting new" do
    login_by_user('user1@example.com')

    next_month_date = Date.today.next_month
    payment_due_date = Date.new(next_month_date.year, next_month_date.month, -1)

    post api_invoices_url,
      params: {
        issued_customer_id: '01HBN3KGE8KXZBYCC05MYCF61J',
        issued_date: '2023-08-25',
        payment_due_date: payment_due_date.strftime('%Y%m%d'),
        claimed_amount_jpy: 2123
      }
    assert_response :bad_request
  end

  test "should accept admin without permission by posting new" do
    login_by_user('user2@example.com')

    next_month_date = Date.today.next_month
    payment_due_date = Date.new(next_month_date.year, next_month_date.month, -1)

    post api_invoices_url,
      params: {
        issued_customer_id: '01HBN3MW1P7YZYPXKK7GMH5786',
        issued_date: '2023-08-25',
        payment_due_date: payment_due_date.strftime('%Y%m%d'),
        claimed_amount_jpy: 2123
      }
    assert_response :success
  end

  test "should reject different organization's resource by posting new" do
    login_by_user('user2@example.com')

    next_month_date = Date.today.next_month
    payment_due_date = Date.new(next_month_date.year, next_month_date.month, -1)

    post api_invoices_url,
      params: {
        issued_customer_id: '01HBN3KGE8KXZBYCC05MYCF61J',
        issued_date: '2023-08-25',
        payment_due_date: payment_due_date.strftime('%Y%m%d'),
        claimed_amount_jpy: 2123
      }
    assert_response :bad_request
  end

  test "should reject unsupported payment due date by posting new" do
    login_by_user('user2@example.com')

    next_month_date = Date.today.next_month
    payment_due_date = Date.new(next_month_date.year, next_month_date.month, -1)

    post api_invoices_url,
      params: {
        issued_customer_id: '01HBN3MW1P7YZYPXKK7GMH5786',
        issued_date: '2023-08-25',
        payment_due_date: Date.today.next_day(1),
        claimed_amount_jpy: 2123
      }
    assert_response :success
    assert_equal(
      {
        'status' => 'validation failed',
        'error' => 'not payable',
      },
      JSON.parse(@response.body),
    )
  end

  test "should get list of invoices" do
    login_by_user('user1@example.com')

    get api_invoices_url,
      params: {
        payment_due_date_begin: '2023-04-01',
        payment_due_date_end: '2023-05-01',
      }
    assert_response :success
    assert_equal(
      {
        'invoices' => [
          {
            'id' => '01HBN3VAKV90SHC6X3Q8TT86DC',
            'issued_customer' => {
              'id' => '01HBN3KQHB86KYS3RKT6H696V5',
              'name' => 'customer 2',
            },
            'status' => 'payed',
            'issued_date' => '2023-02-13',
            'payment_due_date' => '2023-04-30',
            'payment_amount_jpy' => 3610,
          },
        ]
      },
      JSON.parse(@response.body),
    )
  end

  test "should filter list with permissions" do
    login_by_user('user1@example.com')

    get api_invoices_url,
      params: {
        payment_due_date_begin: '2022-10-01',
        payment_due_date_end: '2022-11-01',
      }
    assert_response :success
    @response_body = JSON.parse(@response.body)

    assert_equal [], @response_body['invoices']
  end

  test "should get list of all invoices without permissions for admin" do
    login_by_user('user3@example.com')

    get api_invoices_url,
      params: {
        payment_due_date_begin: '2022-10-01',
        payment_due_date_end: '2022-11-01',
      }
    assert_response :success
    assert_equal(
      {
        'invoices' => [
          {
            'id' => '01HBN3T9ZS6BHAHX24RC8N170J',
            'issued_customer' => {
              'id' => '01HBN3KGE8KXZBYCC05MYCF61J',
              'name' => 'customer 1',
            },
            'status' => 'unpayed',
            'issued_date' => '2022-08-09',
            'payment_due_date' => '2022-10-31',
            'payment_amount_jpy' => 2110,
          },
        ],
      },
      JSON.parse(@response.body),
    )
  end
end
