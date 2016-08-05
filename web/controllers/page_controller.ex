defmodule RethinkDocs.PageController do
  use RethinkDocs.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
