import gleam/dict
import gleam/erlang/process
import shared_types/memory_types.{type MemoryMessage}

pub type ActorPool {
  ActorPool(size: Int, actors: dict.Dict(Int, process.Subject(MemoryMessage)))
}
