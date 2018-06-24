import React, { Component } from 'react';

import Cell from './cell';

export default class UserInfo extends Component {
    render () {
        return (
            <div className={`flex flex-column info ${this.props.current? 'self-info': 'opponent-info'}`}>
                <span>ID: {this.props.id}</span>
                <span>Name: {this.props.name}</span>
                <span>Symbol: {this.props.symbol === 1? 'X' : this.props.symbol === 2 ? 'O' : ''}</span>
                {this.props.win && <span>WINNER</span>}
                {this.props.turn && <span>TURN!!</span>}
            </div>
        );
    }
}