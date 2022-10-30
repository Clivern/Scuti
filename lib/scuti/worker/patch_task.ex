# Copyright 2023 Clivern. All rights reserved.
# Use of this source code is governed by the MIT
# license that can be found in the LICENSE file.

defmodule Scuti.Worker.PatchTask do
  require Logger

  alias Scuti.Module.TaskModule
  alias Scuti.Service.EncryptService

  def run do
    Logger.info("PatchTask Process Started")

    receive do
      msg ->
        Logger.info(
          "Received patch request with id #{msg.id}, task #{msg.task.id}, deployment #{msg.deployment.id}, host #{msg.host.id}"
        )

        payload = Jason.decode!(msg.task.payload)

        body = %{
          deployment_uuid: msg.deployment.uuid,
          host_uuid: msg.host.uuid,
          task_uuid: msg.task.uuid,
          patch_type: payload["patch_type"],
          pre_patch_script: payload["pre_patch_script"] || "",
          patch_script: payload["patch_script"] || "",
          post_patch_script: payload["post_patch_script"] || "",
          post_patch_reboot_option: payload["post_patch_reboot_option"]
        }

        headers = %{
          "X-Webhook-Token": EncryptService.base64(msg.host.secret_key, encode(body))
        }

        # Send the request to the agent
        Logger.info("Send to remote agent #{msg.id}")

        case Req.post!("#{msg.host.agent_address}/api/v1/listen", json: body, headers: headers).status do
          202 ->
            Logger.info("Host agent responded with 200 to #{msg.id}")

          code ->
            Logger.info("Host agent responded with #{code} to #{msg.id}")
        end

        check(msg)
    end
  end

  def check(msg) do
    Logger.info("Check task status #{msg.id}")

    if !TaskModule.is_host_updated_successfully(msg.host.id, msg.task.id) and
         !TaskModule.is_host_failed_to_update(msg.host.id, msg.task.id) do
      Process.sleep(30000)

      check(msg)
    end
  end

  defp encode(%{
         deployment_uuid: deployment_uuid,
         host_uuid: host_uuid,
         task_uuid: task_uuid,
         patch_type: patch_type,
         pre_patch_script: pre_patch_script,
         patch_script: patch_script,
         post_patch_script: post_patch_script,
         post_patch_reboot_option: post_patch_reboot_option
       }) do
    ~c"{\"deployment_uuid\":\"#{deployment_uuid}\",\"host_uuid\":\"#{host_uuid}\",\"task_uuid\":\"#{task_uuid}\",\"patch_type\":\"#{patch_type}\",\"pre_patch_script\":\"#{pre_patch_script}\",\"patch_script\":\"#{patch_script}\",\"post_patch_script\":\"#{post_patch_script}\",\"post_patch_reboot_option\":\"#{post_patch_reboot_option}\"}"
  end
end
