local hiddenItemManager = require("astro.lib.hidden_item_manager")
local isc = require("astro.lib.isaacscript-common")

local mod = RegisterMod("Astrobirth", 1)

hiddenItemManager:Init(mod)

Astro = isc:upgradeMod(mod, { isc.ISCFeature.PLAYER_INVENTORY, isc.ISCFeature.ROOM_HISTORY })

Json = require "json"

require "astro.constants"
require "astro.init"
require "astro.save"
require "astro.eid"
require "astro.stage"
require "astro.utill"
require "astro.entities.init"
require "astro.collectibles.init"
require "astro.trinkets.init"
require "astro.cards.init"
require "astro.player"
require "astro.ban"
require "astro.rooms.init"
-- require "astro.challenges"

require "astro-greedier.award"
