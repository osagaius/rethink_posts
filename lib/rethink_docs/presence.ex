defmodule RethinkDocs.Presence do
  use Phoenix.Presence, otp_app: :rethink_docs,
  pubsub_server: RethinkDocs.PubSub
end
