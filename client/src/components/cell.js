import React, { Component } from 'react';

import SDK from '../sdk';

export default class Cell extends Component {

    onClick = () => {
        if (this.props.text) return;

        SDK.move(this.props.index)
    }

    render () {
        const { text } = this.props;

        return (
            <span className="square" onClick={this.onClick}>{text}</span>
        );
    }
}