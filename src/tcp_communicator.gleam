import communication
import gleam/bit_array
import gleam/bytes_tree
import gleam/erlang/process
import gleam/option.{None}
import gleam/result
import glisten.{Packet}
import shared_types/communication_types.{
  type CommunicationMessage, ProcessMessage,
}

pub fn start_tcp_server() {
  let assert Ok(_) =
    glisten.new(
      fn(_conn) {
        let communication_actor = communication.spawn_new_memory_actor()

        #(communication_actor, None)
      },
      fn(communication_actor, msg, conn) {
        let assert Packet(msg) = msg
        let string_msg =
          msg
          |> bit_array.to_string()
          |> result.unwrap("")

        process.send(communication_actor.data, ProcessMessage(conn, string_msg))

        // let assert Ok(_) = glisten.send(conn, bytes_tree.from_bit_array(msg))
        glisten.continue(communication_actor)
      },
    )
    |> glisten.start(9999)

  echo "Started tcp server on port 9999"

  process.sleep_forever()
}
