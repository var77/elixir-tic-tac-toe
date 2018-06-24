import { combineReducers } from 'redux';
import * as gameReducers from './game.reducers';

export default combineReducers({ ...gameReducers });