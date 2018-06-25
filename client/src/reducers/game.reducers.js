import _ from 'underscore'

import createReducer from '../helpers/createReducer';
import Enum from '../enum';
import { getParameterByName, randomId } from '../helpers'

const { types } = Enum;

window._player =  { id: getParameterByName('id') || randomId(), name: getParameterByName('name') || 'Anonym'}

const defaultBoard = _.toArray(_.groupBy(_.map(_.range(9).fill(0)), (cell, index) => Math.floor(index / 3)))

export const board = createReducer(defaultBoard, {
    [types.setBoard] (state, action) {
        return _.toArray(_.groupBy(action.board, (cell, index) => Math.floor(index / 3)));
    }
});

export const players = createReducer([window._player], {
    [types.setPlayers] (state, action) {
        console.log(action);
        return action.players;
    },
    [types.setWinner] (state, action) {
        return state.map(player => {
            player.win = player.id === action.winner;
            player.draw = action.winner === -1;
            return player;
        });
    },
    [types.setTurn] (state, action) {
        return state.map(player => {
            player.turn = player.symbol === action.turn;
            return player;
        });
    }
});