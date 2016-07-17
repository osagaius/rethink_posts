defmodule RethinkDocs.PostsController do
  use RethinkDocs.Web, :controller
  use RethinkDB.Query

  def index(conn, _params) do
    posts = table("posts")
    |> RethinkDocs.Database.run

    json conn, posts
  end

  def show(conn, params) do
    id = params["id"]|>String.downcase

    json conn, get_post(id)
  end

  def create(conn, params) do
    text = params["text"]

    result = table("posts")
    |> insert(%{text: text})
    |> RethinkDocs.Database.run

    id = result.data["generated_keys"]|>List.first|>String.downcase
    json conn, get_post(id)
  end

  def update(conn, params) do
    text = params["text"]
    id = params["id"]|>String.downcase

    changeset = get_post(id).data |> Map.put(:text, text)

    updated = table("posts")
    |> get(id)
    |> update(changeset, %{return_changes: true})
    |> RethinkDocs.Database.run

    json conn, hd(updated.data["changes"])["new_val"]
  end

  defp get_post(id) do
    table("posts")
    |> get(id)
    |> RethinkDocs.Database.run
  end
end
