RegisterNetEvent('core:client:update_skin', function(skin)
  lib.print.info("Evento de atualização de skin recebido.", skin)

  local model = GetHashKey(skin.model)

  RequestModel(model)
  while not HasModelLoaded(model) do
    Citizen.Wait(0)
  end

  -- Destruir o ped atual antes de aplicar o novo modelo
  local playerPed = PlayerPedId()
  SetEntityAsMissionEntity(playerPed, true, true)
  DeleteEntity(playerPed)

  -- Aplicar o novo modelo
  SetPlayerModel(PlayerId(), model)
  SetModelAsNoLongerNeeded(model)

  -- Obter o ped atualizado
  playerPed = PlayerPedId()
  if skin.components then
    for componentId, drawableData in pairs(skin.components) do
      ---@diagnostic disable-next-line: param-type-mismatch
      SetPedComponentVariation(playerPed, tonumber(componentId), drawableData.drawable, drawableData.texture, 0)
    end
  end
end)
