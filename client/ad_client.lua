vID = nil --id of the vehicle being used on the mission
endpos = nil --end position of delivery
shouldRender = false

--Called from a DeliveryMission object to start client logic
function DeliveryStart(ct)
	vID = ct[1]
	endpos = ct[2]
	endradius = ct[3]
	shouldRender = true
end

--should draw a waypoint or something for the client (eventually)
function ClientLogic()
	if shouldRender then
		--[[local t = Transform3() -- drawing a circle at delivery endpoint
		t:Translate(endpos)
		t:Rotate(Angle(0,math.rad(90),0))
		Render:SetTransform(t)
		Render:DrawCircle(Vector3.Zero, endradius, Color(160, 220, 220))--]]
	end
end

function DeliveryEnd()
	shouldRender = false
end

--Client start function call
Network:Subscribe("DeliveryStartClient", DeliveryStart)
Network:Subscribe("DeliveryEndClient", DeliveryEnd)
Events:Subscribe("Render", ClientLogic) --pretty visuals/pos checking