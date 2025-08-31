import gleam/dict
import gleam/erlang/process
import gleam/otp/actor
import shared_types/memory_types.{
  type Data, type MemoryMessage, Dump, DumpMessage, EmptyMessage, Get,
  IntMessage, IntValue, InvalidMessage, InvalidValue, Set, Shutdown,
  StringMessage, StringValue,
}

pub fn memory_loop(state: Data, message: MemoryMessage) {
  case message {
    Shutdown -> actor.stop()
    Get(reply_to, key) -> {
      case dict.get(state, key) {
        Ok(value) -> {
          case value {
            StringValue(value) -> process.send(reply_to, StringMessage(value))
            IntValue(value) -> process.send(reply_to, IntMessage(value))
            InvalidValue -> process.send(reply_to, InvalidMessage)
          }
        }
        Error(_) -> process.send(reply_to, EmptyMessage)
      }
      actor.continue(state)
    }
    Set(key, value) -> {
      let state = dict.insert(state, key, value)
      actor.continue(state)
    }
    Dump(reply_to) -> {
      process.send(reply_to, DumpMessage(state))
      actor.continue(state)
    }
  }
}

pub fn spawn_new_memory_actor() {
  let assert Ok(spawned_actor) =
    actor.new(dict.new())
    |> actor.on_message(memory_loop)
    |> actor.start

  spawned_actor
}
