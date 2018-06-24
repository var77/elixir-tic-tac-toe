import Enum from '../enum';

const { types } = Enum;

export const setBoard = board => ({
    board,
    type: types.setBoard
});

export const setPlayers = players => ({
    players,
    type: types.setPlayers
});

export const setWinner = winner => ({
    winner,
    type: types.setWinner
});

export const setTurn = turn => ({
    turn,
    type: types.setTurn
});