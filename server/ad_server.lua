--This file contains main logic for the server
--Each instance of a delivery mission is handled by the delivery class file

function PlayerChat(args)
	if args.text == "/ad" then
		if PlayerOnMission(args.player) then
			args.player:SendChatMessage(
			"[Air Delivery] You are currently on an Air Delivery mission. /adquit to end it",
			Color(160, 220, 220))
			return false
		else 
			PickMission(args.player)
		end
	elseif args.text == "/adquit" then
		if activeMissions[args.player:GetId()] ~= nil then
			activeMissions[args.player:GetId()]:End()
		end
	end
end

--Returns a new table of shuffled missions from the table in missions.lua
--Source: mkottman on snippets.luacode.org
function ShuffleMissions(missions)
	local n, order, res = #missions, {}, {}
	for i=1,n do order[i] = { rnd = math.random(), idx = i }	end
	table.sort(order, function(a,b) return a.rnd < b.rnd end)
	for i=1,n do res[i] = missions[order[i].idx] end
	return res
end

--Checks to see if another player is occupying the mission's startpos
function MissionBlocked(mission)
	for player in Server:GetPlayers() do
		if Vector3.Distance(player:GetPosition(), mission.startpos) < 50 then
			return true
		end
	end
	return false
end

--[[Loops through shuffled missions and finds one that isn't blocked.
	If one is one, returns true and starts mission. If all are blocked,
	returns false and notifies player]]--
function PickMission(ply)
	for k, v in pairs(ShuffleMissions(deliveryMissions)) do
		if not MissionBlocked(v) then
			StartMission(ply, v)
			return true
		end
	end
	ply:SendChatMessage(
		"[Air Delivery] All runways are occupied, please try again shortly", 
		Color(160, 220, 220))
	return false
end

--Creates DeliveryMission object, call start on object
function StartMission(ply, mission)
	if PlayerInVehicle(ply) then
		ply:SendChatMessage(
		"[Air Delivery] You cannot start an Air Delivery mission while in a vehicle",
		Color(160, 220, 220))
		return false
	else
		local m = DeliveryMission(ply, mission)	--create mission instance 
		activeMissions[ply:GetId()] = m --adds mission object with key as playerId
		m:Start() -- start the mission
	end
end

--Checks to see if player is in a vehicle/stunt pos/mounted gun
function PlayerInVehicle(ply)
	if ply:GetState() ~= PlayerState.None and 
	ply:GetState() ~= PlayerState.OnFoot then
		return true
	else 
		return false
	end
end

--Checks to see if a player is already on a delivery mission
function PlayerOnMission(ply)
	if activeMissions[ply:GetId()] ~= nil then
		return true
	else 
		return false
	end 
end

--check if player landed (needs major cleaning up)
--player could hit 0mph mid-air above runway and this still fires :(
function PlayerLanded(m, p)
	if Vector3.Distance(m.mission.endpos, Player.GetById(p):GetPosition()) < 
	m.mission.endradius and Player.GetById(p):GetVehicle() == m.veh 
	and Player.GetById(p):GetLinearVelocity():Length() <= 2 then
		return true
	else return false
	end
end

--timer on the server used in MainLoop
elapsedTime = Timer()

--Loops every second to check if people have landed (could use cleaning up)
function MainLoop()
	if elapsedTime:GetSeconds() >= 1 then
		for k, v in pairs(activeMissions) do
			if PlayerLanded(v, k) then
				v:End()
			end
		end
		elapsedTime:Restart()
	end
end

function ModuleUnload()
	for k, v in pairs(activeMissions) do
		v:End()
	end
end

--Holds all the "DeliveryMission" objects thare are currently active
-- Player, DeliveryMission
activeMissions = {}

Events:Subscribe("PlayerChat", PlayerChat)
Events:Subscribe("PostTick", MainLoop)
Events:Subscribe("ModuleUnload", self, ModuleUnload)

