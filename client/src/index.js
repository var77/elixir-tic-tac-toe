import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { createStore } from 'redux';
import reducers from './reducers';
import './css/index.css';
import App from './containers/App';

export const store = createStore(reducers);

ReactDOM.render(<Provider store={store} ><App /></Provider>, document.getElementById('root'));