# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Service.ValidatorService do
  @moduledoc """
  Validator Service
  """
  alias Lynx.Context.UserContext

  def is_number?(value, err) do
    case is_number(value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_integer?(value, err) do
    case is_integer(value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_float?(value, err) do
    case is_float(value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_string?(value, err) do
    case is_binary(value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_list?(value, err) do
    case is_list(value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_not_empty_list?(value, err) do
    case length(value) > 0 do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def not_in?(value, list, err) do
    case value in list do
      false -> {:ok, value}
      true -> {:error, err}
    end
  end

  def in?(value, list, err) do
    case value in list do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_not_empty?(value, err) do
    case value do
      nil -> {:error, err}
      "" -> {:error, err}
      _ -> {:ok, value}
    end
  end

  def is_uuid?(value, err) do
    case Regex.match?(~r/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/, value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_url?(value, err) do
    case Regex.match?(~r/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/, value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_email?(value, err) do
    case Regex.match?(~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/, value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_password?(value, err) do
    case Regex.match?(~r/^(?=.*\D)[^\s]{6,32}$/, value) do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_length_between?(value, min, max, err) do
    case String.length(value) >= min and String.length(value) <= max do
      true -> {:ok, value}
      false -> {:error, err}
    end
  end

  def is_email_used?(email, user_uuid, err) do
    case UserContext.get_user_by_email(email) do
      nil ->
        {:ok, email}

      user ->
        case {user_uuid, user.uuid == user_uuid} do
          {nil, _} ->
            {:error, err}

          {_, false} ->
            {:error, err}

          {_, true} ->
            {:ok, email}
        end
    end
  end
end
