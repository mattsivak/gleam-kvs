import gleam/dict
import gleam/erlang/process

pub type Data =
  dict.Dict(String, DataType)

pub type GeneralMessage {
  StringMessage(String)
  IntMessage(Int)
  DumpMessage(Data)
  InvalidMessage
  EmptyMessage
}

pub type DataType {
  StringValue(value: String)
  IntValue(value: Int)
  InvalidValue
}

pub type MemoryMessage {
  Shutdown
  Set(key: String, value: DataType)
  Get(reply_to: process.Subject(GeneralMessage), key: String)
  Dump(repoll: process.Subject(GeneralMessage))
}
