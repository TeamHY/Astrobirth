local mod = RegisterMod("Astrobirth", 1)

Astro.Fight = mod
Astro.IsFight = true

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
-- require "astro-fight.challenges"

require "astro-greedier.award"
