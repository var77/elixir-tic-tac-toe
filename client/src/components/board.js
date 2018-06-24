import React, { Component } from 'react';

import Cell from './cell';

export default class Board extends Component {
    render () {
        const { board } = this.props;

        return (
            <div className="ticTacToe">
                {board.map((row, i) => <div className="column" key={i}>
                    {row.map((cell, cellIndex) => <Cell key={i * 3 + cellIndex} index={i * 3 + cellIndex} text={cell === 1? 'X' : cell === 2 ? 'O' : ''} />)}
                </div>)}
            </div>
        );
    }
}