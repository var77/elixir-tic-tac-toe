import { store } from '../index.js'
import actions from '../actions';
import _ from 'underscore'

import SDK from './'

export function startRoom ({ turn, players, cells }) {

    if (!_.findWhere(players, { id: window._player.id }).ready) {
        SDK.room.push("room.raedy");
    }

    store.dispatch(actions.setPlayers(players))
    store.dispatch(actions.setTurn(turn))
    store.dispatch(actions.setBoard(cells))
}

export function getMove ({ turn, winner, cells, error }) {
    if (error) return console.error(error);

    store.dispatch(actions.setTurn(winner ? -1 : turn))
    store.dispatch(actions.setWinner(winner))
    store.dispatch(actions.setBoard(cells))
}