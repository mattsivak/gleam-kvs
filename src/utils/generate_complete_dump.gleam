import gleam/dict
import gleam/otp/actor
import shared_types/actor_pool_types.{type ActorPool}
import shared_types/memory_types.{type Data, Dump, DumpMessage, InvalidValue}

pub fn generate_complete_dump(
  actor_pool: ActorPool,
  current_index: Int,
  combined_dump: Data,
) -> Data {
  let current_index = case current_index {
    0 -> 1
    _ -> current_index
  }

  case dict.get(actor_pool.actors, current_index) {
    Ok(current_actor) -> {
      let assert DumpMessage(current_dump) = actor.call(current_actor, 10, Dump)

      let combined_dump =
        dict.combine(combined_dump, current_dump, fn(_, _) { InvalidValue })

      generate_complete_dump(actor_pool, current_index + 1, combined_dump)
    }
    Error(_) -> {
      combined_dump
    }
  }
}
