local wakaba = Astro

local options = {
	listoffset = 200,
	listkey = Keyboard.KEY_F5,
	idleicon = 0,
	selicon = 17,
	lemegetonicon = 18,
	q0icon = 20,
	q1icon = 21,
	q2icon = 22,
	q3icon = 23,
	q4icon = 24,
}

wakaba.descriptions = {}

wakaba.descriptions["ko_kr"] = {}

wakaba.descriptions["ko_kr"].playernotes = {
	-- copy-paste this snippet
	[-50000] = {
		-- icon = "",
		name = "Isaac",
		description = ""
		.. "#"
		.. "",
	},
	-- copy-paste this snippet end
	[-666] = {
		icon = "Blank",
		name = "<플레이어를 찾을 수 없음(혹은 모드로 추가된 플레이어)>",
	},
	[PlayerType.PLAYER_ISAAC] = {
		-- icon = "",
		name = "아이작",
		description = "엄마에게서 도망치기 위해 지하실로 뛰어내린 {{ColorLime}}아이작의 번제{{CR}}의 기본 캐릭터입니다."
		.. "#평균적인 능력치를 가진 캐릭터입니다."
		.. "#{{Collectible105}} {{GoldenKey}}기본 소지 아이템 : 주사위({{Player4}}-> Isaac 처치)"
		.. "",
	},
	[PlayerType.PLAYER_MAGDALENE] = {
		-- icon = "",
		name = "막달레나",
		description = "아이작의 엄마를 모티브로 한 캐릭터입니다."
		.. "#{{Heart}} 체력이 많으나 기본 이동 속도가 매우 느립니다."
		.. "#{{Collectible45}} 기본 소지 아이템 : 맛있는 심장"
		.. "#{{Pill}} {{GoldenKey}}기본 소지 픽업 : 체력 회복 알약(32: 만우절 챌린지 클리어)"
		.. "",
	},
	[PlayerType.PLAYER_CAIN] = {
		-- icon = "",
		name = "카인",
		description = "인류 최초로 살인을 하였습니다."
		.. "#!!! 왼쪽 눈이 안대로 가려져 있어 오른쪽 눈으로만 눈물을 발사합니다. 한 쪽 눈에만 적용되는 눈물은 확률적으로 발사합니다."
		.. "#{{DamageSmall}} 체력이 낮으나 공격력이 높습니다."
		.. "#{{Collectible46}} 기본 소지 아이템 : 행운의 발"
		.. "#{{Trinket19}} {{GoldenKey}}기본 소지 장신구 : 종이 클립({{GreedMode}}: 68{{Coin}})"
		.. "#"
		.. "",
	},
	[PlayerType.PLAYER_JUDAS] = {
		-- icon = "",
		name = "유다",
		description = "예수를 3{{Coin}}에 팔아 버린 예수의 12 제자 중 한명입니다."
		.. "#{{DamageSmall}} 체력이 매우 낮으나 공격력이 매우 높습니다."
		.. "#{{Collectible34}} 기본 소지 아이템 : 벨리알의 책"
		.. "#!!! 유다의 모자는 성경과 무관합니다."
		.. "",
	},
	[PlayerType.PLAYER_BLUEBABY] = {
		-- icon = "",
		name = "???",
		description = "???의 ???입니다."
		.. "#???는 Edmund Mcmillen의 초기작 중 하나인 {{ColorCyan}}Dead Baby Dressup{{CR}}에서 등장하였습니다."
		.. "#{{SoulHeart}} 최대 체력 = 소울하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#??? 캐릭터는 생김새로 인해 'Blue Baby'라는 별명으로도 불립니다."
		.. "#{{Collectible36}} 기본 소지 아이템 : 똥"
		.. "",
	},
	[PlayerType.PLAYER_EVE] = {
		-- icon = "",
		name = "이브",
		description = "성경 최초의 여성이며 원죄를 지어 저주를 받은 후 에덴동산에서 추방되었습니다."
		.. "#공격력이 매우 낮습니다."
		.. "#{{SoulHeart}}이브는 다른 캐릭터에 비해 소울하트 등장 확률이 더 높습니다."
		.. "#{{Collectible117}} 기본 소지 아이템 : 죽은 새"
		.. "#{{Collectible122}} 기본 소지 아이템 : 바빌론의 창녀"
		.. "#{{Blank}} 바빌론의 창녀가 빨간하트가 1칸이여도 발동됩니다."
		.. "#{{Collectible126}} {{GoldenKey}}기본 소지 아이템 : 면도날({{GreedMode}}: 439{{Coin}})"
		.. "",
	},
	[PlayerType.PLAYER_SAMSON] = {
		-- icon = "",
		name = "삼손",
		description = "복받은 영웅 같았지만 실상은 깡패였습니다."
		.. "#순간적 감정에 빡돌며 언제나 피에 굶주려 있습니다."
		.. "#{{Collectible157}} 기본 소지 아이템 : 피의 욕망"
		.. "#{{Trinket34}} {{GoldenKey}}기본 소지 장신구 : 아이의 심장(34: 엄청 어려워 클리어)"
		.. "",
	},
	[PlayerType.PLAYER_AZAZEL] = {
		-- icon = "",
		name = "아자젤",
		description = "인간세계에서 온갖 것들을 유혹한 타천사입니다."
		.. "#남자들에게는 싸우는 법을, 여자들에게는 화장하는 법을 가르쳐 주었습니다."
		.. "#{{DamageSmall}} 공격력이 매우 높습니다."
		.. "#{{Collectible118}} 검은 날개로 날 수 있으며 사거리가 매우 짧은 혈사포를 발사합니다."
		.. "",
	},
	[PlayerType.PLAYER_LAZARUS] = {
		-- icon = "",
		name = "나사로",
		description = "죽었다 되살아난 예수의 절친입니다."
		.. "#{{Collectible332}} 고유 능력 : 나사로의 누더기"
		.. "#{{DamageSmall}} 나사로의 누더기로 부활할 때마다 공격력 +0.5, 최대 체력 -1"
		.. "#부활 상태는 스테이지 진입 시 초기화됩니다."
		.. "#{{Collectible214}} {{GoldenKey}}기본 소지 아이템 : 빈혈증(31: 거꾸로 말해요 클리어)"
		.. "#{{Pill}} 기본 소지 픽업 : 랜덤 알약"
		.. "",
	},
	[PlayerType.PLAYER_EDEN] = {
		-- icon = "",
		name = "에덴",
		description = "그 동산과는 관련이 없습니다."
		.. "#모든 것이 랜덤으로 정해집니다."
		.. "#{{CurseBlind}} 기본 소지 아이템 : ???"
		.. "#{{CurseBlind}} 기본 소지 아이템 : ???"
	},
	[PlayerType.PLAYER_THELOST] = {
		-- icon = "",
		name = "로스트",
		description = "???의 ???입니다. 실종된 포스터와 관련 있을지도?"
		.. "#매우 섬세한 존재입니다. 조심히 다뤄주세요,"
		.. "#상급자용 캐릭터로 기획되어 있다보니 이 캐릭터로 하드 모드 체크리스트를 전부 달성하는 것이 하나의 밈이 되었습니다."
		.. "#{{ColorRed}}한 번이라도 피격 시 즉시 사망합니다.{{CR}} 악마 거지와 헌혈을 조심합시다."
		--.. "#본래 Mcmillen의 의도는 많은 플레이어들이 퍼즐을 풀어 존재를 밝혀내는 상급자용 캐릭터였으나, 데이터 마이닝으로 존재가 유출되었습니다."
		.. "#모든 체력 거래는 무료이나 단 하나만 획득할 수 있습니다."
		.. "#{{Collectible609}} 기본 소지 아이템 : 이터널 주사위"
		.. "#{{Collectible313}} {{GoldenKey}}고유 능력 : 신성한 망토({{GreedMode}}: 879{{Coin}})"
		.. "",
	},
	[PlayerType.PLAYER_LAZARUS2] = {
		-- icon = "",
		name = "나사로",
		description = "죽었다 되살아난 예수의 절친입니다."
		.. "#부활하였으나 이미 죽었던 탓에 피를 흘립니다."
		.. "#{{Collectible214}} 기본 소지 아이템 : 빈혈증"
		.. "#{{Collectible214}} {{GoldenKey}}고유 능력 : 빈혈증(31: 거꾸로 말해요 클리어)"
		.. "",
	},
	[PlayerType.PLAYER_BLACKJUDAS] = {
		-- icon = "",
		name = "검은 유다",
		description = "예수를 3{{Coin}}에 팔아 버린 예수의 12 제자 중 한명...의 그림자입니다."
		.. "#{{BlackHeart}} 최대 체력 = 블랙하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#{{DamageSmall}} 공격력이 매우 높습니다."
		.. "#!!! 이 캐릭터의 체크리스트는 유다의 체크리스트와 공유합니다."
		.. "",
	},
	[PlayerType.PLAYER_LILITH] = {
		-- icon = "",
		name = "릴리스",
		description = "어디서 왔는지 알 수 없지만 신에게 맞서 싸운 몽마입니다."
		.. "#눈을 가려 아무것도 볼 수 없지만 인큐버스가 그녀를 인도합니다."
		.. "#그녀의 힘은 그녀 자신이 아닌 그녀의 친구들로부터 나옵니다. 패밀리어들을 많이 모아줍시다."
		.. "#{{Collectible360}} 고유 능력 : 인큐버스"
		.. "#{{Collectible367}} 기본 소지 아이템 : 친구 상자"
		.. "#{{Collectible412}} 기본 소지 아이템 : 몽마의 자식들"
		.. "",
	},
	[PlayerType.PLAYER_KEEPER] = {
		-- icon = "",
		name = "키퍼",
		description = "???가 탐욕화된 시체입니다."
		.. "#여러 아이작 플레이어들이 탐욕의 비밀 통해 찾아낸 존재입니다."
		.. "#{{CoinHeart}} 체력이 하트가 아닌 코인으로 이루어져 있으며 3칸의 상한을 가집니다."
		.. "#한 번에 3발을 발사하지만 연사가 매우 낮습니다."
		.. "#모든 거래가 동전으로 이루어집니다. 최대체력 1개 당 15{{Coin}}으로 환산됩니다."
		.. "#{{Collectible349}} {{GoldenKey}}기본 소지 아이템 : 나무 동전({{Player14}}-> Isaac 처치)"
		.. "#{{Trinket83}} {{GoldenKey}}기본 소지 장신구 : 상점 열쇠({{Player14}}-> Satan 보스 처치)"
		.. "",
	},
	[PlayerType.PLAYER_APOLLYON] = {
		-- icon = "",
		name = "아폴리온",
		description = "무저갱에서 올라온 석상입니다."
		.. "#모든 것을 파괴하여 공허 속으로 빨아들입니다."
		.. "#천천히 성장하는 석상이므로 인내심을 가집시다."
		.. "#{{Collectible477}} 기본 소지 아이템 : 공허"
		.. "",
	},
	[PlayerType.PLAYER_THEFORGOTTEN] = {
		-- icon = "",
		name = "포가튼",
		description = "???의 무덤에 묻힌 ???의 ???입니다."
		.. "#{{Chargeable}} 공격 키로 뼈를 휘두르며 충전 시 충전 거리만큼 뼈다귀를 부메랑처럼 던질 수 있습니다."
		.. "#{{BoneHeart}} 최대 체력 = 뼈하트의 보정을 받으며 6칸의 상한을 가집니다."
		.. "#{{ColorRed}}뼈하트를 잃으면 패널티 여부 상관 없이 악마방 확률이 감소합니다.{{CR}}"
		.. "#소울하트를 소지할 수 없으며 획득한 소울하트는 영혼인 소울이 소지할 수 있습니다."
		.. "#Ctrl 키를 눌러 소울로 교체할 수 있습니다."
		.. "",
	},
	[PlayerType.PLAYER_THESOUL] = {
		-- icon = "",
		name = "소울",
		description = "???의 무덤에 묻힌 ???의 영혼입니다."
		.. "#본체와는 달리 평범한 눈물을 쏘며 본체의 위치에서 일정 간격 이상으로 벗어날 수 없습니다."
		.. "#활성화 상태에서는 본체는 무적이며 적의 탄환을 막아줄 수 있습니다."
		.. "#{{SoulHeart}} 최대 체력 = 소울하트의 보정을 받으며 6칸의 상한을 가집니다."
		.. "#빨간하트와 뼈하트를 소지할 수 없으며 획득한 뼈하트는 본체인 포가튼이 소지할 수 있습니다."
		.. "#Ctrl 키를 눌러 포가튼으로 교체할 수 있습니다."
		.. "",
	},
	[PlayerType.PLAYER_BETHANY] = {
		-- icon = "",
		name = "베타니",
		description = "나사로의 여동생입니다."
		.. "#소울하트를 소지할 수 없으며 모든 소울하트는 액티브 아이템의 게이지로 사용할 수 있습니다."
		.. "#소울하트 반칸 당 1칸의 게이지로 환산됩니다."
		.. "#{{Collectible584}} 기본 소지 아이템 : 미덕의 책"
		.. "",
	},
	[PlayerType.PLAYER_JACOB] = {
		-- icon = "",
		name = "야곱",
		description = "아이작과 레베카의 둘째 아들입니다."
		.. "#에사우와는 반대로 내향적으로 레베카의 사랑을 받았으며 그의 스튜를 주는 조건으로 에사우의 장자권을 받았습니다."
		.. "#쌍둥이 형인 에사우와 같이 움직이며 둘 중 하나가 죽으면 같이 죽습니다."
		.. "#Ctrl 키를 누른 상태에서는 야곱 혼자만 움직입니다."
		.. "#액티브 아이템은 스페이스바를, 카드/알약은 Ctrl+스페이스바로 사용할 수 있습니다."
		.. "",
	},
	[PlayerType.PLAYER_ESAU] = {
		-- icon = "",
		name = "에사우",
		description = "아이작과 레베카의 첫째 아들입니다."
		.. "#야곱과는 반대로 외향적으로 아이작의 사랑을 받았으며 너무 배고픈 나머지 에사우에게 장자권을 주는 조건으로 스튜를 받았습니다."
		.. "#쌍둥이 동생인 야곱과 같이 움직이며 둘 중 하나가 죽으면 같이 죽습니다."
		.. "#Ctrl 키를 누른 상태에서는 야곱 혼자만 움직입니다."
		.. "#액티브 아이템은 Q를, 카드/알약은 Ctrl+Q로 사용할 수 있습니다."
		.. "",
	},

	-- Tainted
	[PlayerType.PLAYER_ISAAC_B] = {
		-- icon = "",
		name = "아이작(알트)",
		description = "The Broken: 마치 엄마에게 학대당해 망가진 듯한 모습을 하고 있습니다."
		.. "#{{Card81}} 모든 받침대 아이템이 2개의 선택지를 지닙니다."
		.. "#패시브 아이템은 8개까지만 소지할 수 있으며 8개를 전부 소지한 상태에서 아이템 획득 시 선택된 아이템과 교체합니다."
		.. "#교체할 아이템은 Ctrl키로 바꿀 수 있습니다."
		.. "#"
		.. "",
	},
	[PlayerType.PLAYER_MAGDALENE_B] = {
		-- icon = "",
		name = "막달레나(알트)",
		description = "The Dauntless: 머리가 뜯기고 아름다움이 사라져도 계속 적에게 부딪혀야 합니다."
		.. "#기본 체력 2칸을 제외한 모든 체력은 서서히 반칸씩 사라집니다. 사라지는 체력을 잃어도 악마방/천사방 확률에 영향이 없습니다."
		.. "#공격력이 약하지만 적과 접촉시 공격력 x6의 근접 공격을 합니다."
		.. "#체력을 직접적으로 회복시켜주는 아이템의 회복량이 2배가 됩니다."
		.. "#{{Collectible724}} 적을 처치하면 1.5초 후 사라지는 {{Heart}}빨간하트를 드랍합니다."
		.. "#{{Collectible45}} 고유 능력 : 맛있는 심장"
		.. "",
	},
	[PlayerType.PLAYER_CAIN_B] = {
		-- icon = "",
		name = "카인(알트)",
		description = "The Hoarder: 동생을 살해한 죄는 너무나 무거웠습니다."
		.. "#야훼의 저주를 받아 영원한 방랑자가 되었습니다."
		.. "#아이템을 획득할 수 없으며 획득을 시도하면 픽업 아이템으로 분해됩니다."
		.. "#특정 방에서 분해 시 특정 픽업 아이템이 반드시 하나 이상 등장합니다."
		.. "#{{Collectible710}} 고유 능력 : 조합 가방"
		.. "#{{Blank}} 조합 가방에 들어있는 픽업 상황을 볼 수 있습니다."
		.. "#{{Blank}} 완성 시 만들어지는 아이템을 미리 볼 수 있으며 Ctrl키를 누르면 교체할 픽업을 선택할 수 있습니다."
		.. "#{{Blank}} Ctrl키를 꾹 누르면 아이템을 즉시 획득할 수 있습니다."
		.. "",
	},
	[PlayerType.PLAYER_JUDAS_B] = {
		-- icon = "",
		name = "유다(알트)",
		description = "The Deceiver: 배신은 영원합니다."
		.. "#{{BlackHeart}} 최대 체력 = 블랙하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#{{Collectible705}} 고유 능력 : 흑마술"
		.. "#{{Blank}} 흑마술로 통과한 적과 탄환 수만큼 공격력이 일시적으로 대폭 증가합니다."
		.. "#"
		.. "",
	},
	[PlayerType.PLAYER_BLUEBABY_B] = {
		-- icon = "",-
		name = "???(알트)",
		description = "The Soiled: 이제 흙으로 돌아갈 시간입니다."
		.. "#{{SoulHeart}} 최대 체력 = 소울하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#{{Collectible725}} 폭탄을 사용할 수 없으며 폭탄 대신 여러 종류의 똥을 사용합니다."
		.. "#{{PoopPickup}} 폭탄 픽업은 똥 픽업으로 바뀌며 폭탄을 지급하는 아이템은 그 개수만큼 자폭 파리로 변환됩니다."
		.. "#똥은 반드시 순서대로만 사용할 수 잇습니다."
		.. "#가스를 많이 뿜으므로 불장난에 주의합시다."
		--[[ .. "#{{PoopPickup}} 평범한 똥입니다." -- 갈색
		.. "#{{PoopPickup}} 설치 시 자폭파리를 한번에 3마리까지 생성합니다." -- 옥수수
		.. "#{{PoopPickup}} 똥이 사라져도 Red Candle의 불을 남깁니다." -- 불
		.. "#{{PoopPickup}} 주변에 독가스와 가스를 내뿜습니다." -- 녹색
		.. "#{{PoopPickup}} " -- 검은색
		.. "#{{PoopPickup}} " -- 흰색
		.. "#{{PoopPickup}} " -- 돌
		.. "#{{PoopPickup}} 사용 시 1.5초 후 폭발하는 폭탄입니다." -- 폭탄
		.. "#{{PoopPickup}} Butter Bean 아이템 효과와 동일" -- 방귀
		.. "#{{PoopPickup}} Explosive Diarrhea 알약과 동일" --
		.. "#{{PoopPickup}} 바닥에 설사 장판을 깝니다. 설사 장판 위에서 {{DamageSmall}}공격력 +1.5 {{TearsSmall}}연사 +1" ]]
		.. "#{{Collectible715}} 고유 능력 : 고정"
		.. "",
	},
	[PlayerType.PLAYER_EVE_B] = {
		-- icon = "",
		name = "이브(알트)",
		description = "The Curdled: 원죄의 고통은 여전히 끝나지 않았습니다."
		.. "#{{Collectible713}} 고유 능력 : 섬토리움(패시브)"
		.. "#{{Blank}} 공격 키를 2.5초동안 누르고 있으면 체력 반칸을 소모해 클롯 패밀리어를 소환합니다."
		.. "#{{Blank}} 섬토리움 사용시 소환된 모든 클롯을 흡수해 체력으로 변환합니다. 초과된 클롯은 캐릭터의 위치로 옮겨집니다."
		.. "#!!! {{ColorRed}}경고: 섬토리움 사용 중 방을 이동하면 흡수하지 않은 클롯이 전부 증발합니다.{{CR}}"
		.. "#클롯이 없는 상태에서 전체 체력이 반칸 이하일 경우 섬토리움을 직접 들고 싸웁니다."
		.. "",
	},
	[PlayerType.PLAYER_SAMSON_B] = {
		-- icon = "",
		name = "삼손(알트)",
		description = "The Savage: 머리카락이 뽑힌 그는 분노의 학살을 하기 시작했습니다."
		.. "#{{Collectible704}} 고유 능력 : 폭주(패시브)"
		.. "#{{Blank}} 폭주 게이지를 확인할 수 없으며, 피격 시에도 충전됩니다."
		.. "#{{Blank}} 완충 시 강제로 폭주 모드로 돌입합니다."
		.. "",
	},
	[PlayerType.PLAYER_AZAZEL_B] = {
		-- icon = "",
		name = "아자젤(알트)",
		description = "The Benighted: 야훼의 벌을 받아 타천사의 날개는 갈갈이 찢어졌습니다."
		.. "#{{Collectible118}} 검은 날개로 날 수 없으며 굵기가 매우 얇은 혈사포를 발사합니다."
		.. "#혈사포는 적에게 공격력 x0.5의 피해를 입힙니다."
		.. "#{{Collectible704}} 고유 능력 : 각혈"
		.. "#{{Blank}} 재채기가 공격 키를 누르기 시작할 때 발동됩니다."
		.. "#{{Blank}} 재채기로 적을 명중시키면 혈사포의 절반을 충전시킵니다."
		.. "",
	},
	[PlayerType.PLAYER_LAZARUS_B] = {
		-- icon = "",
		name = "나사로(알트-삶)",
		description = "The Enigma: 기적은 언제나 수수께끼입니다."
		.. "#액티브 쿨타임이 채워지는 시점에 죽음 폼으로 강제 전환됩니다."
		.. "#삶/죽음 폼의 능력치 및 아이템은 따로 적용됩니다."
		.. "#{{Blank}} 일부 아이템은 양쪽 폼 모두 적용됨"
		.. "#{{Collectible711}} 고유 능력 : 뒤집기"
		.. "#!!! 뒤집기가 강제로 발동된 경우 받침대의 아이템이 전환되지 않습니다."
		.. "",
	},
	[PlayerType.PLAYER_EDEN_B] = {
		-- icon = "",
		name = "에덴(알트)",
		description = "The Capricious: 이제 그 동산은 오류투성이가 되었습니다."
		.. "#모든 것이 랜덤으로 정해집니다."
		.. "#{{Collectible721}} {{ColorRed}}패널티 피격 시 모든 것이 랜덤으로 정해집니다.{{CR}}"
		.. "#{{CurseBlind}} 기본 소지 아이템 : ???"
		.. "#{{CurseBlind}} 기본 소지 아이템 : ???"
		-- .. "#{{Collectible"..wakaba.Enums.Collectibles.EDEN_STICKY_NOTE.."}} {{GoldenKey}}고유 능력 : 스티커 노트(와카바98: 하이퍼 랜덤 클리어)"
		.. "",
	},
	[PlayerType.PLAYER_THELOST_B] = {
		-- icon = "",
		name = "로스트(알트)",
		description = "The Baleful: 매우 섬세한 존재이지만 이젠 섬세함을 버릴 때입니다."
		.. "#{{Collectible691}} {{Quality2}} 이하의 아이템이 20%의 확률로 리롤되며 'offensive' 태그의 아이템만 등장합니다."
		.. "#{{Blank}} 쓸모없는 아이템이 등장하지 않지만 매우 소중한 방어형 아이템도 등장하지 않습니다."
		.. "#{{Card51}} 기본 소지 픽업 : 신성한 카드"
		.. "#{{Card51}} 카드 등장 시 10%의 확률로 신성한 카드로 교체됩니다."
		-- .. "#{{Collectible"..wakaba.Enums.Collectibles.UNIFORM.."}} {{GoldenKey}}기본 소지 아이템 : 와카바의 교복(와카바9: 드로우 5 클리어)"
		.. "",
	},
	[PlayerType.PLAYER_LAZARUS2_B] = {
		-- icon = "",
		name = "나사로(알트-죽음)",
		description = "The Enigma: 기적은 언제나 수수께끼입니다."
		.. "#액티브 쿨타임이 채워지는 시점에 삶 폼으로 강제 전환됩니다."
		.. "#삶/죽음 폼의 능력치 및 아이템은 따로 적용됩니다."
		.. "#{{Blank}} 일부 아이템은 양쪽 폼 모두 적용됨"
		.. "#{{Collectible711}} 고유 능력 : 뒤집기"
		.. "#!!! 뒤집기가 강제로 발동된 경우 받침대의 아이템이 전환되지 않습니다."
		.. "",
	},
	[PlayerType.PLAYER_LILITH_B] = {
		-- icon = "",
		name = "릴리스(알트)",
		description = "The Harlot: 수많은 정기를 빨아들인 귀신의 사악한 아이가 세상에 나오게 되었습니다."
		.. "#눈이 없어 공격할 수 없지만 겔로가 그녀를 대신하여 공격합니다."
		.. "#{{Collectible728}} 고유 능력 : 겔로(패시브)"
		.. "#공격 키를 누르기 시작하면 태아를 발사하며, 공격 키를 떼면 발사한 태아가 다시 들어갑니다."
		.. "",
	},
	[PlayerType.PLAYER_KEEPER_B] = {
		-- icon = "",
		name = "키퍼(알트)",
		description = "The Miser: 탐욕은 더더욱 탐욕을 추구합니다."
		.. "#{{CoinHeart}} 체력이 하트가 아닌 코인으로 이루어져 있으며 2칸의 상한을 가집니다."
		.. "#한 번에 4발을 발사하지만 연사가 매우 낮습니다."
		.. "#적을 처치 시 3초 후 사라지는 동전을 뿌립니다."
		.. "#일부 경우를 제외한 모든 액티브/패시브 아이템이 동전을 요구합니다."
		.. "#전용 상점이 존재하며 전용 상점은 입장 시 열쇠를 소모하지 않으며 {{TreasureRoom}}/{{BossRoom}}/{{Shop}} 배열의 아이템을 추가로 판매합니다."
		.. "#모든 거래가 동전으로 이루어집니다. 최대체력 1개 당 15{{Coin}}으로 환산됩니다."
		.. "",
	},
	[PlayerType.PLAYER_APOLLYON_B] = {
		-- icon = "",
		name = "아폴리온(알트)",
		description = "The Empty: 무저갱의 깊이는 무한합니다."
		.. "#{{Collectible706}} 고유 능력 : 무저갱"
		.. "",
	},
	[PlayerType.PLAYER_THEFORGOTTEN_B] = {
		-- icon = "",
		name = "포가튼(알트)",
		description = "The Fettered: 이제는 모든 게 구속되어 있습니다."
		.. "#{{SoulHeart}} 최대 체력 = 소울하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#움직일 수 없으며 다른 한 쪽인 영혼에게 모든 걸 맡겨야 합니다."
		.. "#본체는 무적이며 모든 액티브/카드/알약 사용 위치 기준은 본체를 기준으로 합니다."
		.. "",
	},
	[PlayerType.PLAYER_THESOUL_B] = {
		-- icon = "",
		name = "소울(알트)",
		description = "움직이지 못하는 뼈다귀를 보조해 줍니다."
		.. "#공격할 수 없으며 공격 키를 눌러 뼈다귀를 던지는 것으로 공격을 대신합니다."
		.. "#피격 판정은 소울에게만 있으며 적들도 소울을 향해 공격합니다."
		.. "#자유롭게 날 수 있습니다."
		.. "",
	},
	[PlayerType.PLAYER_BETHANY_B] = {
		-- icon = "",
		name = "베타니(알트)",
		description = "The Zealot: 기적은 믿음을 더욱 굳건하게 만듭니다."
		.. "#{{SoulHeart}} 최대 체력 = 소울하트의 보정을 받으며 빨간하트를 채울 수 없습니다."
		.. "#침대에서 자면 소울하트 3칸을 회복합니다."
		.. "#모든 빨간하트는 액티브 아이템의 게이지로 사용할 수 있습니다."
		.. "#빨간하트 반칸 당 1칸의 게이지로 환산됩니다."
		.. "#아이템의 효과 및 효율이 75%로 감소합니다."
		.. "#{{Collectible712}} 고유 능력 : 마도서 레메게톤"
		.. "",
	},
	[PlayerType.PLAYER_JACOB_B] = {
		-- icon = "",
		name = "야곱(알트)",
		description = "The Deserter: 자신이 낚였다는 걸 깨달은 에사우에게 집요하게 쫒기는 신세가 되었습니다."
		.. "#검은 에사우에게 피격 시 유령 상태로 바뀝니다."
		.. "#검은 에사우는 야곱에게 다가오며 지나가는 자리의 적에게 초당 60의 피해를 줍니다."
		.. "#짧은 준비시간 후 야곱에게 돌진하며 지나가는 자리의 적에게 초당 300의 방어무시+화상 피해를 줍니다."
		.. "#{{Collectible722}} 고유 능력 : 아니마 솔라"
		.. "#{{Blank}} 다크 에사우가 없는 상태에서 사용 시 다크 에사우를 바로 소환합니다."
		.. "#{{Blank}} 아니마 솔라가 항상 다크 에사우만을 노립니다."
		.. "",
	},
	[PlayerType.PLAYER_JACOB2_B] = {
		-- icon = "",
		name = "야곱(알트)",
		description = "The Deserter: 자신이 낚였다는 걸 깨달은 에사우에게 집요하게 쫒기는 신세가 되었습니다."
		.. "#!!! 유령 상태: {{ColorRed}}한 번이라도 피격 시 즉시 사망합니다.{{CR}} 악마 거지와 헌혈을 조심합시다."
		.. "#새로운 스테이지 진입 시 유령 상태에서 회복됩니다."
		.. "#검은 에사우는 야곱에게 다가오며 지나가는 자리의 적에게 초당 60의 피해를 줍니다."
		.. "#짧은 준비시간 후 야곱에게 돌진하며 지나가는 자리의 적에게 초당 300의 방어무시+화상 피해를 줍니다."
		.. "#{{Collectible722}} 고유 능력 : 아니마 솔라"
		.. "#{{Blank}} 다크 에사우가 없는 상태에서 사용 시 다크 에사우를 바로 소환합니다."
		.. "#{{Blank}} 아니마 솔라가 항상 다크 에사우만을 노립니다."
		.. "",
	},
	[Astro.Players.LEAH] = {
        -- icon = "",
		name = "레아",
		description = "..."
		.. "#..."
		.. "#..."
		.. "#..."
		.. "",
    },
    [Astro.Players.DIABELLSTAR] = {
        -- icon = "",
		name = "디아벨스타",
		description = "..."
		.. "#..."
		.. "#..."
		.. "#..."
		.. "",
    },
    [Astro.Players.DIABELLSTAR_B] = {
        -- icon = "",
		name = "디아벨제(디아벨스타 알트)", -- 이거 어떻게 표기할까요?
		description = "..."
		.. "#..."
		.. "#..."
		.. "#..."
		.. "",
    },
    [Astro.Players.WATER_ENCHANTRESS] = {
        -- icon = "",
		name = "성전의 수견사",
		description = "..."
		.. "#..."
		.. "#..."
		.. "#..."
		.. "",
    },
    [Astro.Players.SUBJECT_GAMMA] = {
        -- icon = "",
		name = "실험체 감마",
		description = "..."
		.. "#..."
		.. "#..."
		.. "#..."
		.. "",
    },
}

wakaba.KeyboardToString = {}

for key,num in pairs(Keyboard) do

	local keyString = key

	local keyStart, keyEnd = string.find(keyString, "KEY_")
	keyString = string.sub(keyString, keyEnd+1, string.len(keyString))

	keyString = string.gsub(keyString, "_", " ")

	wakaba.KeyboardToString[num] = keyString

end

wakaba.INVDESC_TYPE_PLAYER = -997
wakaba.INVDESC_TYPE_CURSE = -998
wakaba.INVDESC_VARIANT = -1

wakaba._InventoryDesc = RegisterMod("Inventory Descriptions", 1)
--[[ 

	Inventory Descriptions
	List of datas and functions

	- add player note:
	INVDESC:AddPlayerNote(playertype, description, language, playericon)

	- add curse description:
	INVDESC:AddCurse(curseid, cursename, cursedescription, curseicon, language)

	- link collectible for character:
	- some collectibles does not show for some characters, like Lazarus' rags, or Incubus for Lilith
	- This function will link starting items for character if the character technically does not have item
	INVDESC:LinkCollectibleForCharacter(playerType, collectibleType)

	- add blacklist for collectible
	INVDESC:AddCollectibleBlacklist(collectibleType)

	- remove blacklist for collectible
	INVDESC:RemoveCollectibleBlacklist(collectibleType)

 ]]

wakaba._InventoryDesc.defaultItems = {
	[PlayerType.PLAYER_LAZARUS] = {CollectibleType.COLLECTIBLE_LAZARUS_RAGS},
	[PlayerType.PLAYER_LAZARUS2] = {CollectibleType.COLLECTIBLE_ANEMIC},
	--[PlayerType.PLAYER_THELOST] = {CollectibleType.COLLECTIBLE_HOLY_MANTLE},
	[PlayerType.PLAYER_LILITH] = {CollectibleType.COLLECTIBLE_INCUBUS},
	[PlayerType.PLAYER_SAMSON_B] = {CollectibleType.COLLECTIBLE_BERSERK},
	[PlayerType.PLAYER_AZAZEL_B] = {CollectibleType.COLLECTIBLE_HEMOPTYSIS},
	[PlayerType.PLAYER_LILITH_B] = {CollectibleType.COLLECTIBLE_GELLO},
}
wakaba._InventoryDesc.defaultTrinkets = {
	[PlayerType.PLAYER_BLUEBABY] = {TrinketType.TRINKET_LIL_LARVA},
}
wakaba._InventoryDesc.collectibleBlacklist = {

}
wakaba._InventoryDesc.trinketBlacklist = {

}

function wakaba:LinkCollectibleForCharacter(playerType, collectibleType)
	if not playerType or not collectibleType then return end
	if not wakaba._InventoryDesc.defaultItems[playerType] then
		wakaba._InventoryDesc.defaultItems[playerType] = {}
	end
	if not Astro:ContainCollectible(wakaba._InventoryDesc.defaultItems[playerType], collectibleType) then
		table.insert(	wakaba._InventoryDesc.defaultItems[playerType], collectibleType)
	end
end

function wakaba:LinkTrinketForCharacter(playerType, collectibleType)
	if not playerType or not collectibleType then return end
	if not wakaba._InventoryDesc.defaultTrinkets[playerType] then
		wakaba._InventoryDesc.defaultTrinkets[playerType] = {}
	end
	if not Astro:ContainCollectible(wakaba._InventoryDesc.defaultTrinkets[playerType], collectibleType) then
		table.insert(	wakaba._InventoryDesc.defaultTrinkets[playerType], collectibleType)
	end
end

local idesc = wakaba._InventoryDesc
INVDESC = {}
idesc.BackgroundSprite = Sprite()
idesc.BackgroundSprite:Load("gfx/ui/wakaba_idesc_menu.anm2", true)
idesc.BackgroundSprite:SetFrame("Idle",0)

idesc.IconBgSprite = Sprite()
idesc.IconBgSprite:Load("gfx/ui/wakaba_idesc_menu.anm2", true)
idesc.IconBgSprite:SetFrame("ItemIcon",0)


function INVDESC:LinkCollectibleForCharacter(playerType, collectibleType)
	wakaba:LinkCollectibleForCharacter(playerType, collectibleType)
end
function INVDESC:LinkTrinketForCharacter(playerType, collectibleType)
	wakaba:LinkTrinketForCharacter(playerType, collectibleType)
end
function INVDESC:AddCollectibleBlacklist(collectibleType)
	if not collectibleType then return end
	if not Astro:ContainCollectible(wakaba._InventoryDesc.collectibleBlacklist, collectibleType) then
		table.insert(wakaba._InventoryDesc.collectibleBlacklist, collectibleType)
	end
end
function INVDESC:AddTrinketBlacklist(trinkettype)
	if not trinkettype then return end
	if not Astro:ContainCollectible(wakaba._InventoryDesc.trinketBlacklist, trinkettype) then
		table.insert(wakaba._InventoryDesc.trinketBlacklist, trinkettype)
	end
end
function INVDESC:RemoveCollectibleBlacklist(collectibleType)
	if not collectibleType then return end
	for i = 1, #wakaba._InventoryDesc.collectibleBlacklist do
		if wakaba._InventoryDesc.collectibleBlacklist[i] == collectibleType then
			table.remove(wakaba._InventoryDesc.collectibleBlacklist, i)
		end
	end
end
function INVDESC:RemoveTrinketBlacklist(trinkettype)
	if not trinkettype then return end
	for i = 1, #wakaba._InventoryDesc.trinketBlacklist do
		if wakaba._InventoryDesc.trinketBlacklist[i] == trinkettype then
			table.remove(wakaba._InventoryDesc.trinketBlacklist, i)
		end
	end
end

INVDESC:LinkCollectibleForCharacter(Astro.Players.DIABELLSTAR, Astro.Collectible.SINFUL_SPOILS_OF_SUBVERSION_SNAKE_EYE)

local offset = (REPENTANCE and Options.HUDOffset) or 1
local inputready = true

idesc.state = {
	showList = false,
	maxCollectibleID = Isaac.GetItemConfig():GetCollectibles().Size - 1,
	maxTrinketID = Isaac.GetItemConfig():GetTrinkets().Size - 1,
	allowmodifiers = false,
	lists = {
		playernotes = {},
		items = {},
		curses = {},
		collectibles = {},
		lemegetonwisps = {},
		trinkets = {},
		cards = {},
		pills = {},
	},
	listprops = {
		screenx = EID:getScreenSize().X, 
		screeny = EID:getScreenSize().Y,
		max = 1,
		current = 1,
		offset = 0,
		allowmodifiers = false,
	},
	savedtimer = nil,
}


local function getMaxCurseId(curse)
	local maxloop = 0
	while curse > 0 do
		maxloop = maxloop + 1
		curse = curse // 2
	end
	return maxloop
end


function wakaba:TestCollectibles(min, max, allow_mod, filter)
	local items = {}
	for i = min, max do
		local config = Isaac.GetItemConfig()
		if config:GetCollectible(i) then
			if not filter or config:GetCollectible(i).Type == filter then
				table.insert(items, {
					type = 5,
					variant = 100,
					subtype = i,
				})
			end
		end
	end
	idesc.state.showList = true
	idesc.state.allowmodifiers = allow_mod
	local x,y = EID:getScreenSize().X, EID:getScreenSize().Y
	idesc.state.listprops.screenx = x
	idesc.state.listprops.screeny = y

	idesc.state.lists.items = items
	--idesc.state.lists.cards = cards
	--idesc.state.lists.pills = pills

	idesc.state.listprops.max = #items

end

function wakaba:TestTrinkets(min, max, allow_mod, isGolden)
	local items = {}
	local trinkets = {}
	for i = min, max do
		local config = Isaac.GetItemConfig()
		if config:GetTrinket(i) then
			table.insert(trinkets, isGolden and i + 32678 or i)
			table.insert(items, {
				type = 5,
				variant = 350,
				subtype = isGolden and i + 32678 or i,
			})
		end
	end
	idesc.state.showList = true
	idesc.state.allowmodifiers = allow_mod
	local x,y = EID:getScreenSize().X, EID:getScreenSize().Y
	idesc.state.listprops.screenx = x
	idesc.state.listprops.screeny = y

	idesc.state.lists.items = items
	--idesc.state.lists.cards = cards
	--idesc.state.lists.pills = pills

	idesc.state.listprops.max = #items

end

function wakaba:TestCards(min, max, allow_mod, cardType)
	if not allow_mod then
		allow_mod = false
	end
	local items = {}
	for i = min, max do
		local config = Isaac.GetItemConfig()
		if config:GetCard(i) then
			if not cardType or config:GetCard(i).CardType == cardType then
				table.insert(items, {
					type = 5,
					variant = 300,
					subtype = i,
				})
			end
		end
	end
	idesc.state.showList = true
	idesc.state.allowmodifiers = allow_mod
	local x,y = EID:getScreenSize().X, EID:getScreenSize().Y
	idesc.state.listprops.screenx = x
	idesc.state.listprops.screeny = y

	idesc.state.lists.items = items
	--idesc.state.lists.cards = cards
	--idesc.state.lists.pills = pills

	idesc.state.listprops.max = #items

end

function idesc:SetCurrentItemLists()
	local playernotes = {}
	local impitems = {}
	local imptrinkets = {}
	local items = {}
	local currCurse = Game():GetLevel():GetCurses()
	local curses = {}
	local collectibles = {}
	local lemegetonwisps = {}
	local trinkets = {}
	local cards = {}
	local pills = {}
	local currItemNo = 1
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		if not Astro:ContainCollectible(playernotes, playerType) then
			table.insert(playernotes, playerType)
			table.insert(items, {
				type = wakaba.INVDESC_TYPE_PLAYER,
				variant = wakaba.INVDESC_VARIANT,
				subtype = playerType,
			})
		end
		if wakaba._InventoryDesc.defaultItems[playerType] then
			for i, e in ipairs(wakaba._InventoryDesc.defaultItems[playerType]) do
				table.insert(impitems, e)
				table.insert(collectibles, e)
				table.insert(items, {
					type = 5,
					variant = 100,
					subtype = e,
				})
			end
		end
	end
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		local playerType = player:GetPlayerType()
		if wakaba._InventoryDesc.defaultTrinkets[playerType] then
			for i, e in ipairs(wakaba._InventoryDesc.defaultTrinkets[playerType]) do
				table.insert(imptrinkets, e)
				table.insert(trinkets, e)
				table.insert(items, {
					type = 5,
					variant = 350,
					subtype = e,
				})
			end
		end
	end
	for curseId = 0, getMaxCurseId(currCurse) do
		if 1 << curseId & currCurse > 0 then
			table.insert(curses, 1 << curseId)
			table.insert(items, {
				type = wakaba.INVDESC_TYPE_CURSE,
				variant = wakaba.INVDESC_VARIANT,
				subtype = 1 << curseId,
			})
		end
	end
	for i = 0, Game():GetNumPlayers() - 1 do
		local player = Isaac.GetPlayer(i)
		for i = 0, 3 do
			local activeId = player:GetActiveItem(i)
			if activeId > 0 and not Astro:ContainCollectible(collectibles, activeId) then
				table.insert(collectibles, activeId)
				table.insert(items, {
					type = 5,
					variant = 100,
					subtype = activeId,
				})
			end
		end
		for i = 0, 3 do
			local cardId = player:GetCard(i)
			if cardId > 0 and not Astro:ContainCollectible(cards, cardId) then
				table.insert(cards, cardId)
				table.insert(items, {
					type = 5,
					variant = 300,
					subtype = cardId,
				})
			end
		end
		for i = 0, 3 do
			local pillId = player:GetPill(i)
			if pillId > 0 and not Astro:ContainCollectible(pills, pillId) then
				table.insert(pills, pillId)
				table.insert(items, {
					type = 5,
					variant = 70,
					subtype = pillId,
				})
			end
		end

	end
	for itemId = 1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
		for i = 0, Game():GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			local playerType = player:GetPlayerType()
			if not Astro:ContainCollectible(collectibles, itemId) 
			and not Astro:ContainCollectible(impitems, itemId)
			and not Astro:ContainCollectible(wakaba._InventoryDesc.collectibleBlacklist, itemId)
			and player:HasCollectible(itemId, true) then
				table.insert(collectibles, itemId)
				table.insert(items, {
					type = 5,
					variant = 100,
					subtype = itemId,
				})
			end
		end
	end
	for itemId = 1, Isaac.GetItemConfig():GetTrinkets().Size - 1 do
		for i = 0, Game():GetNumPlayers() - 1 do
			local player = Isaac.GetPlayer(i)
			if not Astro:ContainCollectible(trinkets)
			and not Astro:ContainCollectible(wakaba._InventoryDesc.trinketBlacklist, itemId)
			and not Astro:ContainCollectible(imptrinkets, itemId)
			and player:HasTrinket(itemId) then
				table.insert(trinkets, itemId)
				table.insert(items, {
					type = 5,
					variant = 350,
					subtype = itemId,
				})
			end
		end
	end
	local wisps = Isaac.FindByType(EntityType.ENTITY_FAMILIAR, FamiliarVariant.ITEM_WISP, -1, false, false)
	for i, e in ipairs(wisps) do
		if not Astro:ContainCollectible(collectibles, e.SubType) 
		and not Astro:ContainCollectible(lemegetonwisps, e.SubType) 
		and not Astro:ContainCollectible(wakaba._InventoryDesc.collectibleBlacklist, e.SubType)
		then
			table.insert(lemegetonwisps, e.SubType)
			table.insert(items, {
				type = 5,
				variant = 100,
				subtype = e.SubType,
				lemegeton = true,
			})
		end
	end

	idesc.state.lists.impitems = impitems
	idesc.state.lists.items = items
	--idesc.state.lists.cards = cards
	--idesc.state.lists.pills = pills

	idesc.state.listprops.max = #items


end

local function getListCount()
	local x = EID:getScreenSize().X
	local y = EID:getScreenSize().Y
	local validcount = math.ceil((y - offset * 72) / ((EID.lineHeight + 1) * 2))
	return validcount
end

local function resetList()
	idesc.state.showList = false
	idesc.state.listprops.screenx = x
	idesc.state.listprops.screeny = y
	idesc.state.listprops.offset = 0
	idesc.state.listprops.current = 1
	idesc.state.listprops.max = 1
	EID:hidePermanentText()
	for i=0, Game():GetNumPlayers()-1 do

		local player = Isaac.GetPlayer(i)
		local data = player:GetData()

		--enable player controls
		if data.InvDescPlayerPosition then
			data.InvDescPlayerPosition = nil
		end
		if data.InvDescPlayerControlsDisabled then
			player.ControlsEnabled = true
			data.InvDescPlayerControlsDisabled = false
		end
		if idesc.state.savedtimer then
			idesc.state.savedtimer = nil
		end

	end
end

local function onUpdate(player)
	-- if options.listkey == -1 then return end
	if not inputready then 
		inputready = true
		return 
	end
	if Input.IsButtonTriggered(options.listkey, 0) then
		inputready = false
		if Isaac.CountBosses() > 0 or Isaac.CountEnemies() > 0 then
			return
		end
		idesc:SetCurrentItemLists()
		if idesc.state.listprops.max <= 0 then
			return
		end
		idesc.state.showList = not idesc.state.showList
		local x,y = EID:getScreenSize().X, EID:getScreenSize().Y
		idesc.state.listprops.screenx = x
		idesc.state.listprops.screeny = y
		if idesc.state.showList then
			idesc.state.savedtimer = Game().TimeCounter
		else
			resetList()
		end
	end
	if idesc.state.showList then
		if Input.IsButtonTriggered(Keyboard.KEY_ESCAPE, 0) or Input.IsActionTriggered(ButtonAction.ACTION_PAUSE, 0) then
			resetList()
			return
		end
		local listcount = getListCount()
		local listprops = idesc.state.listprops
		if Input.IsActionTriggered(ButtonAction.ACTION_SHOOTUP, player.ControllerIndex or 0) then
			inputready = false
			idesc.state.listprops.current = listprops.current - 1
			if listprops.current - listprops.offset < 2 and listprops.offset > 0 then
				idesc.state.listprops.offset = listprops.offset - 1
			end
			if listprops.current <= 0 then
				idesc.state.listprops.current = listprops.max
				idesc.state.listprops.offset = (listprops.max - listcount) > 0 and listprops.max - listcount or 0
			end
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTLEFT, player.ControllerIndex or 0) then
			inputready = false
			idesc.state.listprops.current = listprops.current - listcount
			idesc.state.listprops.offset = listprops.offset - listcount
			if listprops.offset < 0 then
				idesc.state.listprops.offset = 0
			end
			if listprops.current <= 0 then
				idesc.state.listprops.current = 1
				idesc.state.listprops.offset = 0
			end
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTDOWN, player.ControllerIndex or 0) then
			inputready = false
			idesc.state.listprops.current = listprops.current + 1
			if listprops.current - listprops.offset > (listcount - 2) and listprops.max - listprops.offset > listcount then
				idesc.state.listprops.offset = listprops.offset + 1
			end
			if listprops.current > listprops.max then
				idesc.state.listprops.current = 1
				idesc.state.listprops.offset = 0
			end
		elseif Input.IsActionTriggered(ButtonAction.ACTION_SHOOTRIGHT, player.ControllerIndex or 0) and (listprops.current + listcount) < listprops.max then
			inputready = false
			idesc.state.listprops.current = listprops.current + listcount
			idesc.state.listprops.offset = listprops.offset + listcount
			if listprops.max - listprops.offset < listcount then
				idesc.state.listprops.current = listprops.current - (listcount - (listprops.max - listprops.offset))
				idesc.state.listprops.offset = listprops.max - listcount
			end
			if listprops.current > listprops.max then
				idesc.state.listprops.current = listprops.max
				idesc.state.listprops.offset = listprops.max - listcount
			end
		end
	end
end
idesc:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, onUpdate)

local function isDiff(x, y, x2, y2)
	if math.ceil(x / 1) ~= math.ceil(x2 / 1) then
		return true
	end
	if math.ceil(y / 1) ~= math.ceil(y2 / 1) then
		return true
	end
	return false
end


local function onRender()
	if ModConfigMenu and ModConfigMenu.IsVisible then
		resetList()
		return
	end

	if Encyclopedia and DeadSeaScrollsMenu.IsOpen() then
		resetList()
		return
	end

	if idesc.state.showList and not EID.CachingDescription then

		for i=0, Game():GetNumPlayers()-1 do

			local player = Isaac.GetPlayer(i)
			local data = player:GetData()

			--freeze players and disable their controls
			player.Velocity = Vector(0,0)

			if not data.InvDescPlayerPosition then
				data.InvDescPlayerPosition = player.Position
			end
			player.Position = data.InvDescPlayerPosition
			if not data.InvDescPlayerControlsDisabled then
				player.ControlsEnabled = false
				data.InvDescPlayerControlsDisabled = true
			end

			--disable toggling revelations menu
			if data.input and data.input.menu and data.input.menu.toggle then
				data.input.menu.toggle = false
			end

		end

		local validcount = getListCount()
		local listprops = idesc.state.listprops
		local x, y = EID:getScreenSize().X, EID:getScreenSize().Y
		local x2, y2 = idesc.state.listprops.screenx, idesc.state.listprops.screeny
		if isDiff(x, y, x2, y2) then
			if listprops.current - listprops.offset > validcount then
				idesc.state.listprops.offset = listprops.offset + (listprops.current - listprops.offset - validcount + 2)
				if listprops.offset + validcount > listprops.max then
					idesc.state.listprops.offset = listprops.max - validcount
				end
			end

			--idesc.state.showList = false
			--idesc.state.listprops.screenx = x
			--idesc.state.listprops.screeny = y
			--idesc.state.listprops.offset = 0
			--idesc.state.listprops.current = 1
			--idesc.state.listprops.max = 1
			--EID:hidePermanentText()
			--return
		end
		--idesc.BackgroundSprite:Render(Vector(x, y) / 2, Vector(0,0), Vector(0,0))
		local currentcursor = 1
		local currentlist = {}
		local desc = nil
		for i = 1, validcount do
			currentlist[i] = idesc.state.lists.items[listprops.offset + i]
			if listprops.offset + i == listprops.current then
				currentcursor = i
				desc = EID:getDescriptionObj(currentlist[i].type, currentlist[i].variant, currentlist[i].subtype, nil, idesc.state.allowmodifiers or (currentlist[i].type == 5 and currentlist[i].variant == 100 and currentlist[i].subtype == CollectibleType.COLLECTIBLE_BIRTHRIGHT))
				if currentlist[i].type == wakaba.INVDESC_TYPE_PLAYER then
					lang = EID:getLanguage() or "en_us"
					local entrytables = wakaba.descriptions[lang] and wakaba.descriptions[lang].playernotes or wakaba.descriptions["en_us"].playernotes
					if entrytables[currentlist[i].subtype] then
						local playerID = currentlist[i].subtype
						local entry = entrytables[currentlist[i].subtype]
						local icon = (entry.icon and "{{"..entry.icon.."}}") or (EID:getIcon("Player"..playerID) ~= EID.InlineIcons["ERROR"] and "{{Player"..playerID.."}}" or "{{CustomTransformation}}")
						desc.Name = icon.." "..entry.name
						desc.Description = entry.description
					else
						local entry = entrytables[-666]
						desc.Name = entry.name
					end
				elseif currentlist[i].type == wakaba.INVDESC_TYPE_CURSE then
					lang = EID:getLanguage() or "en_us"
					local entrytables = wakaba.descriptions[lang] and wakaba.descriptions[lang].curses or wakaba.descriptions["en_us"].curses
					if not entrytables[currentlist[i].subtype] then
						desc = EID:getDescriptionObj(currentlist[i].type, currentlist[i].variant, -1)
					end
				end
			end
		end
		EID:renderString("Current item list("..listprops.current.."/"..listprops.max..")", Vector(x - options.listoffset, 36-(EID.lineHeight*2)) - Vector(offset * 10, offset * -10), Vector(1,1), EID:getNameColor())
		EID:renderString("Press ".. wakaba.KeyboardToString[options.listkey].." again to exit", Vector(x - options.listoffset, 36-EID.lineHeight) - Vector(offset * 10, offset * -10), Vector(1,1), EID:getNameColor())
		if true --[[ not Input.IsActionPressed(ButtonAction.ACTION_MAP, EID.player.ControllerIndex) ]] then
			for i, v in pairs(currentlist) do
				local obj = EID:getDescriptionObj(v.type, v.variant, v.subtype, nil, false)
				local extIcon = nil
				if v.type == wakaba.INVDESC_TYPE_PLAYER then
					lang = EID:getLanguage() or "en_us"
					local entrytables = wakaba.descriptions[lang] and wakaba.descriptions[lang].playernotes or wakaba.descriptions["en_us"].playernotes
					if entrytables[currentlist[i].subtype] then
						local playerID = currentlist[i].subtype
						local entry = entrytables[currentlist[i].subtype]
						obj.Name = entry.name
						extIcon = (entry.icon and "{{"..entry.icon.."}}") or (EID:getIcon("Player"..playerID) ~= EID.InlineIcons["ERROR"] and "{{Player"..playerID.."}}" or "{{CustomTransformation}}")
					else
						local entry = entrytables[-666]
						obj.Name = entry.name
						extIcon = "{{CustomTransformation}}"
					end
				elseif v.type == wakaba.INVDESC_TYPE_CURSE then
					lang = EID:getLanguage() or "en_us"
					local entrytables = wakaba.descriptions[lang] and wakaba.descriptions[lang].curses or wakaba.descriptions["en_us"].curses
					if not entrytables[currentlist[i].subtype] then
						obj = EID:getDescriptionObj(v.type, v.variant, -1)
					end
				end

				local height = EID.lineHeight
				local renderpos = Vector(x - options.listoffset, 36 + ((i-1) * (height + 1) * 2)) - Vector(offset * 10, offset * -10)
				local iconrenderpos = renderpos + Vector(-23, ((height + 0) / 2) - 4)
				local qtextrenderpos = renderpos + Vector(-33, (height / 2) + 1)
				local textrenderpos = renderpos + Vector(0, 1)
				local isModded = obj.ModName
				local modIcon = isModded and EID.ModIndicator[obj.ModName] and EID.ModIndicator[obj.ModName].Icon
				local color = i == currentcursor and EID:getColor("{{ColorGold}}", EID:getNameColor()) or EID:getNameColor()
				local frameno = v.lemegeton and options.lemegetonicon or options.idleicon
				frameno = i == currentcursor and options.selicon or frameno
				idesc.IconBgSprite.Scale = Vector(EID.Scale / 3, EID.Scale / 3)
				idesc.IconBgSprite.Color = Color(1, 1, 1, EID.Config["Transparency"], 0, 0, 0)
				if v.type == wakaba.INVDESC_TYPE_PLAYER and extIcon then
					idesc.IconBgSprite:SetFrame("ItemIcon",frameno)
					idesc.IconBgSprite:Render(iconrenderpos, Vector(0,0), Vector(0,0))
					EID:renderString(extIcon, renderpos + Vector(-16.5, (height / 2) + 1), Vector(1,1), color)
				elseif v.type == wakaba.INVDESC_TYPE_CURSE then
					idesc.IconBgSprite:SetFrame("ItemIcon",frameno)
					idesc.IconBgSprite:Render(iconrenderpos, Vector(0,0), Vector(0,0))
					EID:renderInlineIcons({{obj.Icon,0}}, renderpos.X - 18, renderpos.Y + ( (height / 2) + 1))
				elseif v.variant == 100 then
					if REPENTANCE and EID.Config["ShowQuality"] then
						local quality = tonumber(EID.itemConfig:GetCollectible(tonumber(v.subtype)).Quality)
						frameno = (i ~= currentcursor and not v.lemegeton and options["q"..quality.."icon"]) or frameno
						idesc.IconBgSprite:SetFrame("ItemIcon",frameno)
						idesc.IconBgSprite:Render(iconrenderpos, Vector(0,0), Vector(0,0))
						EID:renderString("{{Quality"..quality.."}}", qtextrenderpos, Vector(1,1), color)
					end
					EID:renderInlineIcons({{obj.Icon,0}}, renderpos.X - 18, renderpos.Y + ( (height / 2) + 1))
				elseif v.variant == 350 or v.variant == 300 or v.variant == 70 then
					idesc.IconBgSprite:SetFrame("ItemIcon",frameno)
					idesc.IconBgSprite:Render(iconrenderpos, Vector(0,0), Vector(0,0))
					EID:renderInlineIcons({{obj.Icon,0}}, renderpos.X - 18, renderpos.Y + ( (height / 2) + 1))
				end
				local curName = obj.Name
				curName = v.lemegeton and "{{Collectible"..CollectibleType.COLLECTIBLE_LEMEGETON.."}} "..curName or curName
				
				if EID.Config["TranslateItemName"] ~= 2 then
					local prevLanguage = EID.Config["Language"]
					local curLanguage = EID:getLanguage()
					if curLanguage ~= "en_us" then
						EID.Config["Language"] = "en_us"
						local convertedSub
						if v.variant == 350 then convertedSub = v.subtype % 32768 end
						local englishName = desc.PermanentTextEnglish or EID:getObjectName(v.type, v.variant, convertedSub or v.subtype)
						if v.type == wakaba.INVDESC_TYPE_PLAYER then
							if wakaba.descriptions["en_us"].playernotes[v.subtype] then
								englishName = wakaba.descriptions["en_us"].playernotes[v.subtype].name
							else
								englishName = ""
							end
						elseif v.type == wakaba.INVDESC_TYPE_CURSE then
							if wakaba.descriptions["en_us"].curses[v.subtype] then
								englishName = wakaba.descriptions["en_us"].curses[v.subtype].name
							else
								englishName = ""
							end
						end
						EID.Config["Language"] = prevLanguage
						if EID.Config["TranslateItemName"] == 1 then
							curName = englishName
						elseif EID.Config["TranslateItemName"] == 3 and curName ~= englishName then
							curName = curName.." ("..englishName..")"
						end
					end
				end
				EID:renderString(curName, textrenderpos + Vector(0, isModded and 0 or (EID.lineHeight / 2)), Vector(1,1), color)
				if isModded and obj.ModName and EID.ModIndicator[obj.ModName] and EID.ModIndicator[obj.ModName].Name then
					local rst = ""
					rst = rst .. "{{"..EID.Config["ModIndicatorTextColor"].."}}" .. EID.ModIndicator[obj.ModName].Name
					if modIcon then
						rst = rst .. "{{".. EID.ModIndicator[obj.ModName].Icon .."}}"
					end
					EID:renderString(rst, textrenderpos + Vector(0, EID.lineHeight + 1), Vector(1,1), EID:getTextColor())
				end
			end
		end
		if desc then
			EID:displayPermanentText(desc)
		end
	else
	end
end
idesc:AddCallback(ModCallbacks.MC_POST_RENDER, onRender)

function idesc.InputAction(_, entity, inputHook, buttonAction)
	if options.listkey == -1 then return end
	
	if idesc.state.showList and idesc.state.savedtimer then
		Game().TimeCounter = idesc.state.savedtimer
	elseif idesc.state.savedtimer then 
		idesc.state.savedtimer = nil
	end

	if idesc.state.showList and buttonAction ~= ButtonAction.ACTION_FULLSCREEN and buttonAction ~= ButtonAction.ACTION_CONSOLE and buttonAction ~= options.listkey then

		if inputHook == InputHook.IS_ACTION_PRESSED or inputHook == InputHook.IS_ACTION_TRIGGERED then
			return false
		else
			return 0
		end

	end

end
idesc:AddCallback(ModCallbacks.MC_INPUT_ACTION, idesc.InputAction)





print("Inventory Description for Pudding and Wakaba Loaded")

