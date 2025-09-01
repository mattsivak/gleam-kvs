pub type CommandTokenType {
  EchoCommand
  GetCommand
  SetCommand
  DeleteCommand
  ClearCommand
}

pub type ValueTokenType {
  StringValue(value: String)
  IntValue(value: Int)
}

pub type TcpMessageToken {
  CommandToken(CommandTokenType)
  ValueToken
  SeperatorToken
}

pub type TcpData =
  List(TcpMessageToken)
