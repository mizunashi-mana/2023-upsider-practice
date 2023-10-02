module UserAuthorityActions extend ActiveSupport::Concern
  def user_authority_on_customer(user, customer_id)
    user_authority_on_customer_with_finder(user) do
      UserAuthorityOnCustomer.find_by(
        user: user,
        customer_id: customer_id,
      )
    end
  end

  def user_authority_on_organization(user)
    case user.authority_type_on_organization
    when 'admin' then
      return {
        invoices_new: true,
        invoices_list: true,
      }
    when 'member' then
      @authorities_on_customers = UserAuthorityOnCustomer.where(user_id: @user.id)
      @by_customer_ids = {}
      @authorities_on_customers.each do |authority|
        case authority.authority_type
        when 'operator' then
          @by_customer_ids[authority.customer_id] = user_authority_on_customer_with_finder(user) do
            authority
          end
        else
          raise RuntimeError, "unreachable: Unknown type #{authority.authority_type} of #{authority.id}"
        end
      end

      return {
        by_customer_ids: @by_customer_ids,
      }
    else
      raise RuntimeError, "unreachable: Unknown type #{user.authority_type_on_organization}"
    end
  end

  def user_authority_on_customer_with_finder(user, &find_authority_on_customer)
    case user.authority_type_on_organization
    when 'admin' then
      return {
        invoices_new: true,
        invoices_list: true,
      }
    when 'member' then
      # continue
    else
      raise RuntimeError, "unreachable: Unknown type #{user.authority_type_on_organization}"
    end

    @authority_on_customer = find_authority_on_customer.call()
    if @authority_on_customer.nil?
      return {}
    end

    case @authority_on_customer.authority_type
    when 'operator' then
      return {
        invoices_new: true,
        invoices_list: true,
      }
    when 'viewer' then
      return {
        invoices_list: true,
      }
    else
      raise RuntimeError, "unreachable: Unknown type #{@authority_on_customer.authority_type}"
    end
  end
end
