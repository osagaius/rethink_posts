defmodule RethinkDocs.PostsController do
  use RethinkDocs.Web, :controller
  import RethinkDB.Query

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

    post = get_post(id).data
    changeset = post |> Map.put(:text, text)

    updated = table("posts")
    |> get(id)
    |> update(changeset, %{return_changes: true})
    |> RethinkDocs.Database.run
    changes = updated.data["changes"] |> List.first

    resp = case changes do
      nil ->
        post
      %{} ->
        changes["new_val"]
    end

    json conn, resp
  end

  defp get_post(id) do
    table("posts")
    |> get(id)
    |> RethinkDocs.Database.run
  end
end
