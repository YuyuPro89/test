-- Copyright © 2016 g0ld <g0ld@tuta.io>
-- This work is free. You can redistribute it and/or modify it under the
-- terms of the Do What The Fuck You Want To Public License, Version 2,
-- as published by Sam Hocevar. See the COPYING file for more details.

local sys    = require "Libs/syslib"
local game   = require "Libs/gamelib"
local Quest  = require "Quests/Quest"
local Dialog = require "Quests/Dialog"

local name        = 'Boulder Badge'
local description = 'from route 2 to route 3'

local BoulderBadgeQuest = Quest:new()
function BoulderBadgeQuest:new()
	return Quest.new(BoulderBadgeQuest, name, description, 14)
end

function BoulderBadgeQuest:isDoable()
	if not hasItem("HM01 - Cut") and self:hasMap()
	then
		return true
	end
	return false
end

function BoulderBadgeQuest:isDone()
	return getMapName() == "Pokecenter Route 3" or getMapName() == "Viridian City" or getMapName() == "Pokecenter Viridian"
end



function BoulderBadgeQuest:Route2()
	if game.inRectangle(0, 90, 24, 130) then
		if  not game.isTeamFullyHealed() then
			return moveToCell(9,130)
		else
			return moveToCell(15,96)
		end
	elseif game.inRectangle(0, 0, 28, 42) then
		self:route2Up()
	else
		error("BoulderBadgeQuest:Route2(): This position should not be possible")
	end
end

function BoulderBadgeQuest:Route2Stop()
	return moveToCell(3,2)
end

function BoulderBadgeQuest:ViridianForest()
	if not game.hasPokemonWithMove("Dragon Rage") and not hasItem("TM23 - Dragon-Rage") then
		return moveToCell(19,38)
	else
		moveToCell(12,15)
	end
end

function BoulderBadgeQuest:ViridianMaze()
	if not game.hasPokemonWithMove("Dragon Rage") and not hasItem("TM23 - Dragon-Rage") then
		log("Getting tm23-DragonRage for charmander")
		return talkToNpcOnCell(199,32)
	elseif hasItem("TM23 - Dragon-Rage") and not game.hasPokemonWithMove("Dragon Rage") then 
		return useItemOnPokemon("TM23 - Dragon-Rage", 1)
	elseif isNpcOnCell(186,52) then
		return talkToNpcOnCell(186,52)
	else 
		return moveToCell(16,60)
	end
end

function BoulderBadgeQuest:Route2Stop2()
	return moveToCell(3,2)
end

function BoulderBadgeQuest:route2Up()
	if self.registeredPokecenter ~= "Pokecenter Pewter" then
		return moveToCell(26,0)
	elseif not self:isTrainingOver()  then
		return moveToGrass()
	else
		return moveToCell(26,0)
	end
end

function BoulderBadgeQuest:PewterCity()
	if isNpcOnCell(23,22) then
		talkToNpcOnCell(23,22)
	elseif not game.isTeamFullyHealed() or self.registeredPokecenter ~= "Pokecenter Pewter" then
		return moveToCell(24,35)
	elseif self:needPokemart() then
		return moveToCell(37,26)
	elseif not self:isTrainingOver() then
		log("Training until "..self.level .."Lv")
		return moveToCell(15,55)
	elseif self:isTrainingOver() and not hasItem("Boulder Badge") then
		return moveToCell(23,21)
	else
		return moveToCell(65,32)
	end
end

function BoulderBadgeQuest:PewterGym()
	self.level = 14
	if hasItem("Boulder Badge") or  not game.isTeamFullyHealed() then
		return moveToCell(7,14)
	else
		return talkToNpcOnCell(7,5)
	end
end

function BoulderBadgeQuest:Route3()
	return moveToCell(79,21)
end

function BoulderBadgeQuest:PokecenterPewter()
	if   getPokemonName(1) ~= "Charmander" and getPokemonName(1) ~= "Charmeleon"  and not hasItem("Boulder Badge")  then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				return depositPokemonToPC(1)
			else
				return
			end
		else
			return usePC()
		end
	elseif  getTeamSize() >=2 and not hasItem("HM03 - Surf") then
		if isPCOpen() then
			if isCurrentPCBoxRefreshed() then
				return depositPokemonToPC(2)
			else
				return
			end
		else
			return usePC()
		end
				
	else
		self:pokecenter(8,22)
	end
end


function BoulderBadgeQuest:PewterPokemart()
	self:pokemart(6,12)
end

return BoulderBadgeQuest
