local hiddenItemManager = require("astro.lib.hidden_item_manager")
local isc = require("astro.lib.isaacscript-common")

local mod = RegisterMod("Redrawn_Mod", 1)

hiddenItemManager:Init(mod)

Astro = isc:upgradeMod(mod, {isc.ISCFeature.PLAYER_INVENTORY})

Json = require "json"

require "astro.init"
require "astro.save"
require "astro.stage"
require "astro.things"
require "astro.utill"
require "astro.void-portal"
-- require "astro.extracard"
require "astro.collectibles.init"
require "astro.trinkets.init"
require "astro.cards"
require "astro.player"
require "astro.ban"
require "astro.mega-chest"
require "astro.room"
require "astro.epic"
