import gleam/bytes_tree
import gleam/otp/actor
import glisten
import shared_types/communication_types.{
  type CommunicationMessage, type Data, ProcessMessage, Shutdown,
}

pub fn communication_loop(state: Data, message: CommunicationMessage) {
  case message {
    Shutdown -> actor.stop()
    ProcessMessage(conn, msg) -> {
      case msg {
        "ping" <> _ -> {
          let assert Ok(_) = glisten.send(conn, bytes_tree.from_string("pong"))
          actor.continue(state)
        }
        _ -> actor.continue(state)
      }

      actor.continue(state)
    }
  }
}

pub fn spawn_new_memory_actor() {
  let assert Ok(spawned_actor) =
    actor.new(0)
    |> actor.on_message(communication_loop)
    |> actor.start

  spawned_actor
}
