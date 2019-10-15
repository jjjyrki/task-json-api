defmodule TaskApi.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias TaskApi.Services.Authenticator
  alias TaskApi.Repo
  alias TaskApi.Accounts.User
  alias TaskApi.AuthToken

  schema "users" do
    has_many :auth_tokens, TaskApi.AuthToken
    field :name, :string
    field :email, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    timestamps()
  end

  def sign_in(email, password) do
    case Comeonin.Bcrypt.check_pass(Repo.get_by(User, email: email), password) do
      {:ok, user} ->
        token = Authenticator.generate_token(user)
        Repo.insert(Ecto.build_assoc(user, :auth_tokens, %{token: token}))
      err -> err
    end
  end
  
  def sign_out(conn) do
    case Authenticator.get_auth_token(conn) do
      {:ok, token} ->
        case Repo.get_by(AuthToken, %{token: token}) do
          nil -> {:error, :not_found}
          auth_token -> Repo.delete(auth_token)
        end
      error -> error
    end
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :password, :name])
    |> validate_required([:email, :password, :name])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> put_password_hash
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset

end
