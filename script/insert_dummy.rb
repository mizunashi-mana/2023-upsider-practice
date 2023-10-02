org1 = Organization.find_by(id: '01HBNN3SXGWEQ5EZYP4KFDXVTQ')
if org1.nil?
  org1 = Organization.new(
    id: '01HBNN3SXGWEQ5EZYP4KFDXVTQ',
    name: 'organization 1',
    representative_name: 'repr of org1',
    contact_phone_number: '000000000',
    post_number: '000-0000',
    address: 'addr of org1',
  )
  org1.save!
end

user1 = User.find_by(email: 'user1@example.com')
if user1.nil?
  user1 = User.new(
    email: 'user1@example.com',
    password: 'pass1',
    organization: org1,
    authority_type_on_organization: :member,
  )
  user1.save!
end

customer1 = Customer.find_by(id: '01HBNN49DF2VZTHSE4BQQ05TAD')
if customer1.nil?
  customer1 = Customer.new(
    id: '01HBNN49DF2VZTHSE4BQQ05TAD',
    name: 'customer 1',
    target_organization: org1,
    representative_name: 'repr of cust1',
    contact_phone_number: '000000000',
    post_number: '000-0000',
    address: 'addr of cust1',
  )
  customer1.save!
end

customer_bank_account1 = CustomerBankAccount.find_by(id: '01HBNNGDT8D0Y4XKVAKRKSW9T9')
if customer_bank_account1.nil?
  customer_bank_account1 = CustomerBankAccount.new(
    id: '01HBNNGDT8D0Y4XKVAKRKSW9T9',
    owner_customer: customer1,
    name: 'name of acct1',
    bank_name: 'bank of acct1',
    bank_branch_name: 'branch of acct1',
    account_number: '00000000',
  )
  customer_bank_account1.save!
end

user_authority_on_customer1 = UserAuthorityOnCustomer.find_by(id: '01HBNNJW9MTGX070DC4HC9H0XN')
if user_authority_on_customer1.nil?
  user_authority_on_customer1 = UserAuthorityOnCustomer.new(
    id: '01HBNNJW9MTGX070DC4HC9H0XN',
    user: user1,
    customer: customer1,
    authority_type: :operator,
  )
  user_authority_on_customer1.save!
end
