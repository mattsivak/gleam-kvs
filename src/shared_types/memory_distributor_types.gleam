import shared_types/memory_actor_pool_types.{type ActorPool}
import shared_types/memory_types.{type MemoryMessage}

pub type DistributorMessage {
  DistributorMessage(distribution_key: String, message: MemoryMessage)
}

pub type DistributorState {
  DistributorState(actors: ActorPool)
}
