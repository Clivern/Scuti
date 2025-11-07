# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.UserContext do
  @moduledoc """
  User Context Module

  Manages user-related operations, including CRUD for users, sessions, and metadata.
  """

  import Ecto.Query

  alias Scuti.Repo
  alias Scuti.Model.{Team, UserMeta, User, UserSession, UserTeam}

  @doc """
  Creates a new user with the provided attributes.
  """
  def new_user(attrs \\ %{}) do
    %{
      email: attrs.email,
      name: attrs.name,
      password_hash: attrs.password_hash,
      verified: attrs.verified,
      last_seen: attrs.last_seen,
      role: attrs.role,
      api_key: attrs.api_key,
      uuid: Map.get(attrs, :uuid, Ecto.UUID.generate())
    }
  end

  @doc """
  Creates a new user meta with the provided attributes.
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      user_id: meta.user_id
    }
  end

  @doc """
  Creates a new user session with the provided attributes.
  """
  def new_session(session \\ %{}) do
    %{
      value: session.value,
      expire_at: session.expire_at,
      user_id: session.user_id
    }
  end

  @doc """
  Creates a new user record in the database.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves a user record by its ID.
  """
  def get_user_by_id(id) do
    Repo.get(User, id)
  end

  @doc """
  Retrieves the ID of a user by its UUID.
  """
  def get_user_id_with_uuid(uuid) do
    case get_user_by_uuid(uuid) do
      nil -> nil
      user -> user.id
    end
  end

  @doc """
  Retrieves a user record by its UUID.
  """
  def get_user_by_uuid(uuid) do
    from(
      u in User,
      where: u.uuid == ^uuid
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieves a user by API key.
  """
  def get_user_by_api_key(api_key) do
    from(
      u in User,
      where: u.api_key == ^api_key
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Retrieves a user by email.
  """
  def get_user_by_email(email) do
    from(
      u in User,
      where: u.email == ^email
    )
    |> limit(1)
    |> Repo.one()
  end

  @doc """
  Updates an existing user with new attributes.
  """
  def update_user(user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a specified user from the database.
  """
  def delete_user(user) do
    Repo.delete(user)
  end

  @doc """
  Retrieves all users from the database.
  """
  def get_users() do
    Repo.all(User)
  end

  @doc """
  Retrieves users with pagination support.
  """
  def get_users(offset, limit) do
    from(u in User,
      order_by: [desc: u.inserted_at],
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Counts all users in the database.
  """
  def count_users() do
    from(u in User, select: count(u.id))
    |> Repo.one()
  end

  @doc """
  Creates and saves new user metadata.
  """
  def create_user_meta(attrs \\ %{}) do
    %UserMeta{}
    |> UserMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates and saves a new user session.
  """
  def create_user_session(attrs \\ %{}) do
    %UserSession{}
    |> UserSession.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieves user metadata by its ID.
  """
  def get_user_meta_by_id(id) do
    Repo.get(UserMeta, id)
  end

  @doc """
  Updates an existing user's metadata.
  """
  def update_user_meta(user_meta, attrs) do
    user_meta
    |> UserMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates an existing user's session.
  """
  def update_user_session(user_session, attrs) do
    user_session
    |> UserSession.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes specified user metadata from the database.
  """
  def delete_user_meta(user_meta) do
    Repo.delete(user_meta)
  end

  @doc """
  Deletes specified user session from the database.
  """
  def delete_user_session(user_session) do
    Repo.delete(user_session)
  end

  @doc """
  Deletes all sessions for a specific user.
  """
  def delete_user_sessions(user_id) do
    from(
      u in UserSession,
      where: u.user_id == ^user_id
    )
    |> Repo.delete_all()
  end

  @doc """
  Retrieves user metadata by user ID and key.
  """
  def get_user_meta_by_id_key(user_id, meta_key) do
    from(u in UserMeta,
      where: u.user_id == ^user_id,
      where: u.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Retrieves a user's session by user ID and value.
  """
  def get_user_session_by_id_value(user_id, value) do
    from(u in UserSession,
      where: u.user_id == ^user_id,
      where: u.value == ^value
    )
    |> Repo.one()
  end

  @doc """
  Retrieves all sessions for a specific user.
  """
  def get_user_sessions(user_id) do
    from(
      u in UserSession,
      where: u.user_id == ^user_id
    )
    |> Repo.all()
  end

  @doc """
  Retrieves all metadata for a specific user.
  """
  def get_user_metas(user_id) do
    from(
      u in UserMeta,
      where: u.user_id == ^user_id
    )
    |> Repo.all()
  end

  @doc """
  Adds a user to a team with generated UUID for the association.
  """
  def add_user_to_team(user_id, team_id) do
    %UserTeam{}
    |> UserTeam.changeset(%{
      user_id: user_id,
      team_id: team_id,
      uuid: Ecto.UUID.generate()
    })
    |> Repo.insert()
  end

  @doc """
  Removes a specified user from a team.
  """
  def remove_user_from_team(user_id, team_id) do
    from(
      u in UserTeam,
      where: u.user_id == ^user_id,
      where: u.team_id == ^team_id
    )
    |> Repo.delete_all()
  end

  @doc """
  Removes a specified user from a team using UUID.
  """
  def remove_user_from_team_by_uuid(uuid) do
    from(
      u in UserTeam,
      where: u.uuid == ^uuid
    )
    |> Repo.delete_all()
  end

  @doc """
  Retrieves teams associated with a specific user.
  """
  def get_user_teams(user_id) do
    teams = []

    items =
      from(
        u in UserTeam,
        where: u.user_id == ^user_id
      )
      |> Repo.all()

    for item <- items do
      team = Repo.get(Team, item.team_id)

      case team do
        nil -> nil
        _ -> teams ++ team
      end
    end
  end

  @doc """
  Count users associated with a specific team.
  """
  def count_team_users(team_id) do
    from(u in UserTeam,
      select: count(u.id),
      where: u.team_id == ^team_id
    )
    |> Repo.one()
  end

  @doc """
  Count teams associated with a specific user.
  """
  def count_user_teams(user_id) do
    from(u in UserTeam,
      select: count(u.id),
      where: u.user_id == ^user_id
    )
    |> Repo.one()
  end

  @doc """
  Retrieve users associated with a specific team.
  """
  def get_team_users(team_id) do
    users = []

    items =
      from(
        u in UserTeam,
        where: u.team_id == ^team_id
      )
      |> Repo.all()

    for item <- items do
      user = Repo.get(User, item.user_id)

      case user do
        nil -> nil
        _ -> users ++ user
      end
    end
  end

  @doc """
  Validate if a given user ID exists.
  """
  def validate_user_id(id) do
    !!get_user_by_id(id)
  end

  @doc """
  Validate if a given user UUID exists.
  """
  def validate_user_uuid(uuid) do
    !!get_user_by_uuid(uuid)
  end
end
