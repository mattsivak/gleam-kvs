import glisten

pub type Data =
  Int

pub type CommunicationMessage {
  Shutdown
  ProcessMessage(conn: glisten.Connection(Nil), msg: String)
}
