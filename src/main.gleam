import gleam/dict
import gleam/erlang/process
import gleam/io
import gleam/otp/actor
import memory_actor_pool
import memory_distributor
import shared_types/memory_actor_pool_types.{ActorPool}
import shared_types/memory_distributor_types.{DistributorMessage}
import shared_types/memory_types.{
  EmptyMessage, Get, IntMessage, IntValue, Set, StringMessage, StringValue,
}
import tcp_communicator
import utils/generate_complete_dump.{generate_complete_dump}

const memory_shard_count = 32

pub fn main() {
  io.println("Hello from otp_test!")

  let actor_pool =
    memory_actor_pool.spawn_pool_of_memory_actors(
      memory_shard_count,
      ActorPool(size: 0, actors: dict.new()),
    )

  let distributor = memory_distributor.spawn_message_distributor(actor_pool)

  // Send some messages to the actor
  actor.send(
    distributor.data,
    DistributorMessage("a", Set("a", StringValue("1"))),
  )
  actor.send(distributor.data, DistributorMessage("b", Set("b", IntValue(2))))

  let assert StringMessage(_) =
    actor.call(distributor.data, 10, fn(subject) {
      DistributorMessage("a", Get(subject, "a"))
    })

  let assert IntMessage(_) =
    actor.call(distributor.data, 10, fn(subject) {
      DistributorMessage("b", Get(subject, "b"))
    })

  let assert EmptyMessage =
    actor.call(distributor.data, 10, fn(subject) {
      DistributorMessage("c", Get(subject, "c"))
    })

  let combined_dump = generate_complete_dump(actor_pool, 0, dict.new())

  echo combined_dump

  tcp_communicator.start_tcp_server()

  process.sleep_forever()
}
