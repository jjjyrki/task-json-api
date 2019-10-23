defmodule TaskApi.Tasks.Todo do
  use Ecto.Schema
  import Ecto.Changeset
  alias TaskApi.Accounts.User

  schema "todos" do
    field :description, :string
    field :done, :boolean, default: false
    field :title, :string
    belongs_to :user, User, foreign_key: :user_id
    
    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    IO.inspect(attrs)
    todo
    |> cast(attrs, [:title, :description, :done, :user_id])
    |> validate_required([:title, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
