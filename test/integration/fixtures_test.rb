class FixturesTest < ActionDispatch::IntegrationTest
  test "fixtures of customer bank accounts should be valid" do
    CustomerBankAccount.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end

  test "fixtures of customers should be valid" do
    Customer.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end

  test "fixtures of organizations should be valid" do
    Organization.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end

  test "fixtures of users should be valid" do
    User.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end

  test "fixtures of invoices should be valid" do
    Invoice.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end

  test "fixtures of user authorities on customers should be valid" do
    UserAuthorityOnCustomer.all.map do |item|
      assert item.valid?, "Should be valid without #{item.errors.inspect}"
    end
  end
end
