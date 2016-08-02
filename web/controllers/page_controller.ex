defmodule RethinkDocs.PageController do
  use RethinkDocs.Web, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
    conn|>halt
  end
end
