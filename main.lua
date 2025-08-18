local mod = RegisterMod("Astrobirth", 1)

Astro.Fight = mod
Astro.IsFight = true

Json = require "json"

local function GetCurrentModPath()
	if debug then
		return string.sub(debug.getinfo(GetCurrentModPath).source, 2) .. "/../"
	end
	--use some very hacky trickery to get the path to this mod
	local _, err = pcall(require, "")
	local _, basePathStart = string.find(err, "no file '", 1)
	local _, modPathStart = string.find(err, "no file '", basePathStart)
	local modPathEnd, _ = string.find(err, ".lua'", modPathStart)
	local modPath = string.sub(err, modPathStart + 1, modPathEnd - 1)
	modPath = string.gsub(modPath, "\\", "/")
	modPath = string.gsub(modPath, "//", "/")
	modPath = string.gsub(modPath, ":/", ":\\")

	return modPath
end
Astro.Fight.modPath = GetCurrentModPath()

Json = require "json"

require "astro-fight.init"
require "astro-fight.stage"
require "astro-fight.entities.init"
require "astro-fight.collectibles.init"
require "astro-fight.trinkets.init"
require "astro-fight.cards.init"
require "astro-fight.player"
require "astro-fight.ban"
require "astro-fight.next-ban"
require "astro-fight.rooms.init"
require "astro-fight.translate"
-- require "astro-fight.challenges"

require "astro-greedier.award"
