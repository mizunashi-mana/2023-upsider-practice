import React from 'react';
import * as ReactQuery from 'react-query';
import './App.css';

const App: React.FC = () => {
  const { isLoading, error, data } = ReactQuery.useQuery('session', async () => {
    const response = await fetch('/api/sessions/get');
    if (response.status == 200) {
      return await response.json();
    } else {
      throw new Error(`Failed to get session: status=${response.status}`);
    }
  });

  if (isLoading) {
    return <UnloadedView></UnloadedView>;
  } else if (data === undefined) {
    throw error;
  } else {
    switch (data.status) {
      case 'unauthorized':
        return <UnauthorizedView></UnauthorizedView>;
      case 'authorized':
        return <AuthorizedView email={data.email}></AuthorizedView>;
    }
  }
};

export default App;

const UnloadedView: React.FC = () => {
  return (<p>Loading... Please wait.</p>);
};

const UnauthorizedView: React.FC = () => {
  const queryClient = ReactQuery.useQueryClient();
  const { isLoading, isError, data, mutate: loginMutate } = ReactQuery.useMutation(
    async (formData: FormData) => {
      const response = await fetch('/api/sessions/login', {
        method: 'POST',
        body: formData,
      });
      if (response.status == 200) {
        return await response.json();
      } else {
        throw new Error(`Failed to get session: status=${response.status}`);
      }
    },
    {
      onSuccess: (data) => {
        if (data.result == 'success') {
          queryClient.invalidateQueries('session');
        }
      },
    },
  );

  return (<>
    <form onSubmit={(event) => {
      event.preventDefault();
      loginMutate(new FormData(event.target as HTMLFormElement));
    }}>
      <div className='form-group'>
        <label htmlFor="login_email">E-mail</label>
        <input id="login_email" name="email" type="text" required></input>
      </div>

      <div className='form-group'>
        <label htmlFor="login_password">Password</label>
        <input id="login_password" name="password" type="password" required></input>
      </div>

      <button type="submit" disabled={isLoading}>Login</button>

      {(() => {
        if (isLoading) {
          return <p>Submitting...</p>;
        } else if (isError) {
          return <p>Error!</p>;
        } else if (data && data.result == 'fail') {
          return <p>Failed.</p>;
        } else {
          return <></>;
        }
      })()}
    </form>
  </>);
};

const AuthorizedView: React.FC<{
  email: string;
}> = (props) => {
  return (<>
    <SessionView email={props.email}></SessionView>
    <InvoicesListView></InvoicesListView>
    <NewInvoiceView></NewInvoiceView>
  </>);
};

const SessionView: React.FC<{
  email: string;
}> = (props) => {
  const queryClient = ReactQuery.useQueryClient();
  const logoutMutation = ReactQuery.useMutation(
    async () => {
      const response = await fetch('/api/sessions/logout', {
        method: 'POST',
      });
      if (response.status == 200) {
        return await response.json();
      } else {
        throw new Error(`Failed to get session: status=${response.status}`);
      }
    },
    {
      onSuccess: () => {
        queryClient.invalidateQueries('session');
      },
    },
  );

  return (<>
    <p>Logined: {props.email}</p>
    <form onSubmit={(event) => {
      event.preventDefault();
      logoutMutation.mutate();
    }}>
      <button type="submit" disabled={logoutMutation.isLoading}>Logout</button>
      {(() => {
        if (logoutMutation.isLoading) {
          return <p>Submitting...</p>;
        } else if (logoutMutation.isError) {
          return <p>Error!</p>;
        } else {
          return <></>;
        }
      })()}
    </form>
  </>);
};

type Invoice = {
  id: string;
  issued_customer: {
    id: string;
    name: string;
  };
  status: string;
  issued_date: string;
  payment_due_date: string;
  payment_amount_jpy: number;
}

const InvoicesListView: React.FC = () => {
  const [paymentDueDateBegin, setPaymentDueDateBegin] = React.useState<string | undefined>(undefined);
  const [paymentDueDateEnd, setPaymentDueDateEnd] = React.useState<string | undefined>(undefined);
  const { isLoading, isError, data } = ReactQuery.useQuery(
    ['invoices_list', paymentDueDateBegin, paymentDueDateEnd],
    async () => {
      if (paymentDueDateBegin === undefined || paymentDueDateEnd === undefined) {
        return [];
      }

      const invoicesUrl = new URL('/api/invoices', location.href);
      invoicesUrl.searchParams.append('payment_due_date_begin', paymentDueDateBegin);
      invoicesUrl.searchParams.append('payment_due_date_end', paymentDueDateEnd);
      const response = await fetch(invoicesUrl);
      if (response.status == 200) {
        const responseBody = await response.json();
        return responseBody.invoices;
      } else {
        throw new Error(`Failed to get invoices: status=${response.status}`);
      }
    },
  );

  return (<>
    <form onSubmit={(event) => {
      event.preventDefault();
      const formData = new FormData(event.target as HTMLFormElement);

      const begin = formData.get('payment_due_date_begin');
      if (typeof begin === 'string' && begin.length > 0) {
        setPaymentDueDateBegin(begin);
      }

      const end = formData.get('payment_due_date_end');
      if (typeof end === 'string' && end.length > 0) {
        setPaymentDueDateEnd(end);
      }
    }}>
      <input name="payment_due_date_begin" type="date" required></input>
      <input name="payment_due_date_end" type="date" required></input>
      <button type="submit" disabled={isLoading}>Load</button>
      {(() => {
        if (isLoading) {
          return <p>Loading...</p>;
        } else if (isError) {
          return <p>Error!</p>;
        } else {
          return <></>;
        }
      })()}
    </form>
    <table>
      <thead>
        <tr>
          <th>ID</th>
          <th>Customer</th>
          <th>Status</th>
          <th>Issued</th>
          <th>Due</th>
          <th>Amount (¥)</th>
        </tr>
      </thead>
      <tbody>
        {data && data.map((invoice: Invoice) => {
          return (
            <tr key={invoice.id}>
              <td>{invoice.id}</td>
              <td title={invoice.issued_customer.id}>{invoice.issued_customer.name}</td>
              <td>{invoice.status}</td>
              <td>{invoice.issued_date}</td>
              <td>{invoice.payment_due_date}</td>
              <td>{invoice.payment_amount_jpy}</td>
            </tr>
          );
        })}
      </tbody>
    </table>
  </>);
};

const NewInvoiceView: React.FC = () => {
  const queryClient = ReactQuery.useQueryClient();
  const { isLoading, isError, data, mutate: invoiceNewMutate } = ReactQuery.useMutation(
    async (formData: FormData) => {
      const response = await fetch('/api/invoices', {
        method: 'POST',
        body: formData,
      });
      if (response.status == 200) {
        return await response.json();
      } else {
        throw new Error(`Failed to get session: status=${response.status}`);
      }
    },
    {
      onSuccess: () => {
        queryClient.invalidateQueries('invoices_list');
      },
    },
  );

  return (<>
    <h2>New Invoice</h2>
    <form onSubmit={(event) => {
      event.preventDefault();
      invoiceNewMutate(new FormData(event.target as HTMLFormElement));
    }}>
      <div className='form-group'>
        <label htmlFor="new_invoice_issued_customer">Issued Customer ID</label>
        <input id="new_invoice_issued_customer" name="issued_customer_id" type="text" required></input>
      </div>

      <div className='form-group'>
        <label htmlFor="new_invoice_issued_date">Issued Date</label>
        <input id="new_invoice_issued_date" name="issued_date" type="date" required></input>
      </div>

      <div className='form-group'>
        <label htmlFor="new_invoice_payment_due_date">Payment Due Date</label>
        <input id="new_invoice_payment_due_date" name="payment_due_date" type="date" required></input>
      </div>

      <div className='form-group'>
        <label htmlFor="new_invoice_claimed_amount_jpy">Claimed Amount (¥)</label>
        <input id="new_invoice_claimed_amount_jpy" name="claimed_amount_jpy" type="number" required></input>
      </div>

      <button type="submit" disabled={isLoading}>Register</button>

      {(() => {
        if (isLoading) {
          return <p>Submitting...</p>;
        } else if (isError) {
          return <p>Error!</p>;
        } else if (data !== undefined) {
          switch (data.status) {
            case 'ok':
              return <p>Registered: {data.invoice_id}</p>;
            case 'validation failed':
              return <p>Failed: {data.error}</p>;
            default:
              throw new Error(`Unknown status: ${data.status}`);
          }
        }
      })()}
    </form>
  </>);
};
