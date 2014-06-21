--class thats used when a player begins a delivery mission
class ("DeliveryMission")

--Create mission with given player and mission
function DeliveryMission:__init(ply, mission)
	self.ply = ply
	self.mission = mission
	self.vehtemp = { --vehicle template
		position = self.mission.startpos,
		angle = self.mission.startang,
		model_id = self.mission.vehicleID
	}
	self.veh = nil --the id of spawned vehicle
end

function DeliveryMission:Start()
	self.veh = Vehicle.Create(self.vehtemp) --create vehicles from temp
	self.veh:SetInvulnerable(false) --incase server has invulernable on
	self.veh:SetDeathRemove(true) --remove if crash
	self.veh:SetUnoccupiedRemove(true) --remove if unoccupied
	
	self.ply:Teleport(self.mission.startpos, self.mission.startang)
	self.ply:EnterVehicle( self.veh, VehicleSeat.Driver )
	self.ply:SendChatMessage(self.mission.desc, Color(160, 220, 220))
	
	--client only needs to know these two things below
	ct = { 
		self.veh:GetId(),
		self.mission.endpos,
		self.mission.endradius
	}
	
	--Start the clientside logic
	Network:Send(self.ply, "DeliveryStartClient", ct)
end

function DeliveryMission:End()
	if IsValid(self.veh) then
		self.veh:Remove() --remove the vehicle used
	end
	self.veh = nil
	activeMissions[self.ply:GetId()] = nil --remove from activeMissions table
	self.ply:SendChatMessage(
		"[Air Delivery] Delivery Completed!", 
		Color(160, 220, 220))
	Network:Send(self.ply, "DeliveryEndClient")
end
