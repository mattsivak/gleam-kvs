import gleam/dict
import gleam/otp/actor
import shared_types/actor_pool_types.{type ActorPool}
import shared_types/distributor_types.{
  type DistributorMessage, type DistributorState, DistributorState,
}
import utils/phash2.{phash2}

pub fn distributor_loop(state: DistributorState, message: DistributorMessage) {
  let actor_index = phash2(message.distribution_key, state.actors.size)

  let assert Ok(actor) = dict.get(state.actors.actors, actor_index)

  actor.send(actor, message.message)

  actor.continue(state)
}

pub fn spawn_message_distributor(actor_pool: ActorPool) {
  let assert Ok(spawned_actor) =
    actor.new(DistributorState(actors: actor_pool))
    |> actor.on_message(distributor_loop)
    |> actor.start

  spawned_actor
}
