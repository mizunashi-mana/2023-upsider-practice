import React from 'react';
import ReactDOM from 'react-dom/client';
import * as ReactQuery from 'react-query';
import App from './App.tsx';
import './index.css';

const queryClient = new ReactQuery.QueryClient();

ReactDOM.createRoot(document.getElementById('root')!).render(
  <React.StrictMode>
    <ReactQuery.QueryClientProvider client={queryClient}>
      <App></App>
    </ReactQuery.QueryClientProvider>
  </React.StrictMode>,
);
