import _ from 'underscore';
import { Socket } from 'phoenix';

import { startRoom, getMove } from './handlers'


const host = 'ws://127.0.0.1:4000';

const logger = (kind, msg, data) => console.log(`${kind}: ${msg}`, data)
const token = btoa(JSON.stringify(window._player))

class SDK  {

    constructor () {
        this.socket = new Socket(`${host}/socket`, { logger, params: { token } });
        this.room = null;
        this.user = null;
    }

    init () {
        this.socket.connect()
        this.socket.onOpen( ev => {
            console.log("OPEN", ev)
            this.user = this.socket.channel(`user:${window._player.id}`)

            this.user.join().receive("ok", () => this.user.push("user.welcome"))

            this.user.on("user.welcome", (room) => {
                if (!room) return;
                this.joinRoom(room.id, true);
                startRoom(room);
            });
        })
        this.socket.onError( ev => console.log("ERROR", ev) )
        this.socket.onClose( e => console.log("CLOSE", e))
    }

    joinRoom (roomId) {
        this.room = this.socket.channel(`room:${roomId}`, {});

        this.room.join()
            .receive("ignore", () => console.log("auth error"))
            .receive("ok", () => this.room.push("room.ready"))

        this.room.onError(e => console.log("something went wrong", e))
        this.room.onClose(e => console.log("channel closed", e))

        this.room.on("room.start", startRoom)
        this.room.on("room.make.move", getMove)
    }

    move (cell) {
        this.room.push("room.move", { cell })
    }


}

export default new SDK();