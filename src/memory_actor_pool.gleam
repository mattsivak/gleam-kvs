import gleam/dict
import memory.{spawn_new_memory_actor}
import shared_types/memory_actor_pool_types.{type ActorPool, ActorPool}

pub fn spawn_pool_of_memory_actors(
  count: Int,
  actor_pool: ActorPool,
) -> ActorPool {
  case count {
    0 -> actor_pool
    _ -> {
      let spawned_actor = spawn_new_memory_actor()
      let actors = dict.insert(actor_pool.actors, count, spawned_actor.data)
      let actor_pool_size = actor_pool.size + 1
      spawn_pool_of_memory_actors(
        count - 1,
        ActorPool(size: actor_pool_size, actors: actors),
      )
    }
  }
}
