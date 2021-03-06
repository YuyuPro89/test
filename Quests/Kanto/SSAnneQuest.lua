-- Copyright © 2016 Rympex <Rympex@noemail>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'SSAnne Quest'
local description = 'Completes the SSAnne'
local level       = 2

local dialogs = {
	NeedRegisterTicket = Dialog:new({ 
		"has been booked in the passenger registry of S.S. Anne!",
		"pc is already registered to your"
	}),
	PcGetRegisterDone = Dialog:new({ 
		"welcome aboard to"
	}),
	RegisterTicketDone = Dialog:new({ 
		"enjoy your passengership on the"
	}),
	NeedPharmacist = Dialog:new({ 
		"did you speak to the pharmacist"
	}),
	TrashBinCheck = Dialog:new({ 
		"is empty"
	}),
	PharmacistWorking = Dialog:new({ 
		"explore the ballroom for now"
	}),
	KitchenDone = Dialog:new({ 
		"that the captain is cured in a timely fashion"
	})
}

local SSAnneQuest = Quest:new()

function SSAnneQuest:new()
	return Quest.new(SSAnneQuest, name, description, level, dialogs)
end

function SSAnneQuest:isDoable()
	return self:hasMap()
end

function SSAnneQuest:SSAnneBasement()
	return moveToCell(27,3) --SSAnne 1F
end

function SSAnneQuest:SSAnne2FRoom6()
	if dialogs.PharmacistWorking.state then
		return moveToCell(5,11) --SSAnne 2F
	else
		return talkToNpcOnCell(9,9)
	end
end

function SSAnneQuest:SSAnne2FCaptainRoom()
	if hasItem("Secret Potion") and not hasItem("HM01 - Cut") then
		return talkToNpcOnCell(5,4)
	else
		return moveToCell(2,11) --SSAnne 2F
	end
end

function SSAnneQuest:BallroomSSAnne()
	if isNpcOnCell(2,20) then
			return talkToNpcOnCell(2, 20)
	else
		return moveToCell(22,12) --SSAnne 3F
	end
end

function SSAnneQuest:SSAnne3F()
	if not hasItem("Secret Potion") then
		if not hasItem("HM01 - Cut") then
			return moveToCell(6,7) --Ballroom SS Anne
		end
	else
		return moveToCell(27,4) --SSAnne 2F
	end
end

function SSAnneQuest:SSAnne2F()
	if hasItem("Secret Potion") then
		if isNpcOnCell(26, 4) then
			return talkToNpcOnCell(26,4)
		else
			return moveToCell(27,4) --SSAnne 2F Captain Room
		end
	elseif not hasItem("HM01 - Cut") then
		if dialogs.PharmacistWorking.state then
			return moveToCell(2,17) --SSAnne 3F
		else
			if isNpcOnCell(28, 18) and not self.trashBinLeftovers then -- Item: LeftOvers
				if not dialogs.TrashBinCheck.state then
					return talkToNpcOnCell(28, 18)
				else
					dialogs.TrashBinCheck.state = false
					self.trashBinLeftovers = true
					return
				end
			else
				return moveToCell(22,15) --SSAnne 2F Room6
			end
		end
	else
		return moveToCell(4,4) --SSAnne 1F
	end
end

function SSAnneQuest:SSAnne1F()
	if hasItem("Secret Potion") then
		return moveToCell(2,11) --SSAnne 2F
	elseif not hasItem("HM01 - Cut") then
		if dialogs.RegisterTicketDone.state then
			if dialogs.NeedPharmacist.state or dialogs.KitchenDone.state then
				return moveToCell(2,11) --SSAnne 2F
			else
				return moveToCell(2,19) --SSAnne 1F Kitchen
			end
		else
			return talkToNpcOnCell(16,3)
		end
	else
		return moveToCell(15,2) --Vermilion City
	end
end

function SSAnneQuest:SSAnne1FKitchen()
	if dialogs.NeedPharmacist.state or dialogs.KitchenDone.state then
		return moveToCell(7,2) --SSAnne 1F
	else
		-- GET ITEMS CHECK
		if isNpcOnCell(14, 9) and not self.trashBin2Kitchen then -- Item: Pecha Berry - [Mission Pharmacist]
			if not dialogs.TrashBinCheck.state then
				return talkToNpcOnCell(14, 9)
			else
				dialogs.TrashBinCheck.state = false
				self.trashBin2Kitchen = true
				return
			end
		else
			return talkToNpcOnCell(5, 3)
		end
	end
end

function SSAnneQuest:SSAnneBasementRoom5()
	if isNpcOnCell(5, 10) then
		if dialogs.NeedRegisterTicket.state then -- Complete the Register on Left-PC and Exit
			if not dialogs.PcGetRegisterDone.state then
				return talkToNpcOnCell(6, 3)
			else
				return talkToNpcOnCell(5, 10)
			end
		else
			return talkToNpcOnCell(5, 10)
		end
	else
		return moveToCell(5,11) --SSAnne Basement
	end
end



return SSAnneQuest
