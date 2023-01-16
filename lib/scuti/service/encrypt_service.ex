# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Service.EncryptService do
  @moduledoc """
  Slug Service
  """

  @doc """
  HMAC encrypt base16
  """
  def base16(key, data) do
    Base.encode16(:crypto.mac(:hmac, :sha256, key, data), case: :lower)
  end

  @doc """
  HMAC encrypt base64
  """
  def base64(key, data) do
    Base.encode64(:crypto.mac(:hmac, :sha256, key, data))
  end
end
