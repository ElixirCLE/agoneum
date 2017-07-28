defmodule Agoneum.Account do
  @moduledoc """
  The boundary for the Account system.
  """

  import Ecto.Query, warn: false
  alias Agoneum.Repo
  alias Agoneum.{Account.User, Games.Game}

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Retrieves the user that has the given email. Forces the email to be lowercase
  before comparison.

  If no user is found with that email, it returns nil.
  """
  @spec get_user_by_email(any) :: %User{} | nil
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: String.downcase(email))
  end
  def get_user_by_email(_), do: nil

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  # TODO: Revisit function name, actions, etc. Add doc
  def create_user_admin(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  @doc """
  Adds a new game (or games) to the user's collection.
  """
  def add_games(%User{} = user, %Game{} = game), do: add_games(user, [game])
  def add_games(%User{} = user, games) do
    game_changesets = games ++ user.games
                      |> Enum.map(&Ecto.Changeset.change/1)
                      |> Enum.uniq()

    user
    |> change_user()
    |> Ecto.Changeset.put_assoc(:games, game_changesets)
    |> Repo.update()
  end

  @doc """
  Removes a game (or games) from the user's collection.
  """
  def remove_games(%User{} = user, %Game{} = game), do: remove_games(user, [game])
  def remove_games(%User{} = user, games) do
    remaining_games = Enum.reject(user.games, fn(game) -> Enum.member?(games, game) end)
    game_changesets = Enum.map(remaining_games, &Ecto.Changeset.change/1)

    user
    |> change_user()
    |> Ecto.Changeset.put_assoc(:games, game_changesets)
    |> Repo.update()
  end
end
