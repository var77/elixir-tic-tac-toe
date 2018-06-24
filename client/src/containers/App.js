import React, { Component } from 'react';
import { connect } from 'react-redux';
import { bindActionCreators } from 'redux';
import actionCreators from '../actions/index';

import Board from '../components/board'
import UserInfo from '../components/userInfo'
import { randomId } from '../helpers'

import SDK from '../sdk';

class App extends Component {
    constructor (props) {
        super(props)

        this.state = {
            roomId: randomId()
        }
    }

    async componentDidMount () {
        SDK.init()
    }

    onInputChange = (e) => {
        this.setState({ roomId: e.target.value });
    }

    joinRoom = () => {
        SDK.joinRoom(this.state.roomId)
    }

    render () {
        let { board, players } = this.props;

        return (
            <div>
                <div className="join-room">
                    <input type="text" placeholder="roomId" value={this.state.roomId} onChange={this.onInputChange}/>
                    <button onClick={this.joinRoom}>Join</button>
                </div>
                <div className="flex space-around">
                    {players[0] && <UserInfo current={window._player.id === players[0].id} {...players[0]}/>}
                    <Board board={board}/>
                    {players[1] && <UserInfo current={window._player.id === players[1].id} {...players[1]}/>}
                </div>
            </div>
        );
    }
}

const mapStateToProps = state => ({
    board: state.board,
    players: state.players
});


const mapDispatchToProps = dispatch => bindActionCreators(actionCreators, dispatch);

export default connect(mapStateToProps, mapDispatchToProps)(App);