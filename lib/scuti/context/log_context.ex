# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Context.LogContext do
  @moduledoc """
  Log Context Module
  """

  import Ecto.Query
  alias Scuti.Repo
  alias Scuti.Model.{LogMeta, Log}

  @doc """
  Get a new log
  """
  def new_log(log \\ %{}) do
    %{
      record: log.record,
      user_id: log.user_id,
      team_id: log.team_id,
      host_id: log.host_id,
      host_group_id: log.host_group_id,
      deployment_id: log.deployment_id,
      uuid: Ecto.UUID.generate()
    }
  end

  @doc """
  Get a log meta
  """
  def new_meta(meta \\ %{}) do
    %{
      key: meta.key,
      value: meta.value,
      log_id: meta.log_id
    }
  end

  @doc """
  Create a new log
  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a log by ID
  """
  def get_log_by_id(id) do
    Repo.get(Log, id)
  end

  @doc """
  Get log by UUID
  """
  def get_log_by_uuid(uuid) do
    from(
      s in Log,
      where: s.uuid == ^uuid
    )
    |> Repo.one()
  end

  @doc """
  Update a log
  """
  def update_log(log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a log
  """
  def delete_log(log) do
    Repo.delete(log)
  end

  @doc """
  Retrieve all logs
  """
  def get_logs() do
    Repo.all(Log)
  end

  @doc """
  Retrieve logs
  """
  def get_logs(offset, limit) do
    from(s in Log,
      limit: ^limit,
      offset: ^offset
    )
    |> Repo.all()
  end

  @doc """
  Create a new log meta attribute
  """
  def create_log_meta(attrs \\ %{}) do
    %LogMeta{}
    |> LogMeta.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Retrieve a log meta by id
  """
  def get_log_meta_by_id(id) do
    Repo.get(LogMeta, id)
  end

  @doc """
  Update a log meta
  """
  def update_log_meta(log_meta, attrs) do
    log_meta
    |> LogMeta.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Delete a log meta
  """
  def delete_log_meta(log_meta) do
    Repo.delete(log_meta)
  end

  @doc """
  Get log meta by log id and key
  """
  def get_log_meta_by_id_key(log_id, meta_key) do
    from(
      s in LogMeta,
      where: s.log_id == ^log_id,
      where: s.key == ^meta_key
    )
    |> Repo.one()
  end

  @doc """
  Get log metas
  """
  def get_log_metas(log_id) do
    from(
      s in LogMeta,
      where: s.log_id == ^log_id
    )
    |> Repo.all()
  end
end
