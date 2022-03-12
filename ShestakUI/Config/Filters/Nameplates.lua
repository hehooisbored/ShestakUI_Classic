local T, C, L, _ = unpack(select(2, ...))
if C.nameplate.enable ~= true then return end

----------------------------------------------------------------------------------------
--	The best way to add or delete spell is to go at www.wowhead.com, search for a spell.
--	Example: Polymorph -> http://www.wowhead.com/spell=118
--	Take the number ID at the end of the URL, and add it to the list
----------------------------------------------------------------------------------------
local function SpellName(id)
	local name = GetSpellInfo(id)
	if name then
		return name
	else
		print("|cffff0000WARNING: spell ID ["..tostring(id).."] no longer exists! Report this to Shestak.|r")
		return "Empty"
	end
end

T.DebuffWhiteList = {
	-- Death Knight
	[SpellName(108194)] = true,	-- Asphyxiate
	[SpellName(47476)] = true,	-- Strangulate
	[SpellName(55078)] = true,	-- Blood Plague
	[SpellName(55095)] = true,	-- Frost Fever
	-- Druid
	[SpellName(33786)] = true,	-- Cyclone
	[SpellName(339)] = true,	-- Entangling Roots
	[SpellName(164812)] = true,	-- Moonfire
	[SpellName(164815)] = true,	-- Sunfire
	[SpellName(58180)] = true,	-- Infected Wounds
	[SpellName(155722)] = true,	-- Rake
	[SpellName(1079)] = true,	-- Rip
	-- Hunter
	[SpellName(3355)] = true,	-- Freezing Trap
	[SpellName(194279)] = true,	-- Caltrops
	[SpellName(13812)] = true,	-- Explosive Trap
	[SpellName(217200)] = true,	-- Barbed Shot
	-- Mage
	[SpellName(118)] = true,	-- Polymorph
	[SpellName(31661)] = true,	-- Dragon's Breath
	[SpellName(122)] = true,	-- Frost Nova
	[SpellName(44457)] = true,	-- Living Bomb
	[SpellName(114923)] = true,	-- Nether Tempest
	[SpellName(120)] = true,	-- Cone of Cold
	-- Monk
	[SpellName(115078)] = true,	-- Paralysis
	-- Paladin
	[SpellName(20066)] = true,	-- Repentance
	[SpellName(853)] = true,	-- Hammer of Justice
	[SpellName(183218)] = true,	-- Hand of Hindrance
	-- Priest
	[SpellName(204213)] = true,	-- Purge the Wicked
	[SpellName(9484)] = true,	-- Shackle Undead
	[SpellName(8122)] = true,	-- Psychic Scream
	[SpellName(64044)] = true,	-- Psychic Horror
	[SpellName(15487)] = true,	-- Silence
	[SpellName(589)] = true,	-- Shadow Word: Pain
	[SpellName(34914)] = true,	-- Vampiric Touch
	-- Rogue
	[SpellName(6770)] = true,	-- Sap
	[SpellName(2094)] = true,	-- Blind
	[SpellName(1776)] = true,	-- Gouge
	-- Shaman
	[SpellName(51514)] = true,	-- Hex
	[SpellName(3600)] = true,	-- Earthbind
	[SpellName(196840)] = true,	-- Frost Shock
	[SpellName(188389)] = true,	-- Flame Shock
	[SpellName(197209)] = true,	-- Lightning Rod
	-- Warlock
	[SpellName(710)] = true,	-- Banish
	[SpellName(6789)] = true,	-- Mortal Coil
	[SpellName(5782)] = true,	-- Fear
	[SpellName(5484)] = true,	-- Howl of Terror
	[SpellName(6358)] = true,	-- Seduction
	[SpellName(30283)] = true,	-- Shadowfury
	[SpellName(603)] = true,	-- Doom
	[SpellName(980)] = true,	-- Agony
	[SpellName(146739)] = true,	-- Corruption
	[SpellName(48181)] = true,	-- Haunt
	[SpellName(348)] = true,	-- Immolate
	[SpellName(30108)] = true,	-- Unstable Affliction
	-- Warrior
	[SpellName(5246)] = true,	-- Intimidating Shout
	[SpellName(132168)] = true,	-- Shockwave
	[SpellName(115767)] = true,	-- Deep Wounds
	-- Racial
	[SpellName(20549)] = true,	-- War Stomp (Tauren)
	[SpellName(107079)] = true,	-- Quaking Palm (Pandaren)
}

for _, spell in pairs(C.nameplate.debuffs_list) do
	T.DebuffWhiteList[SpellName(spell)] = true
end

T.DebuffBlackList = {
	-- [SpellName(spellID)] = true,	-- Spell Name
}

T.BuffWhiteList = {
	[SpellName(226510)] = true,	-- Sanguine Ichor
}

for _, spell in pairs(C.nameplate.buffs_list) do
	T.BuffWhiteList[SpellName(spell)] = true
end

T.BuffBlackList = {
	-- [SpellName(spellID)] = true,	-- Spell Name
}

T.PlateBlacklist = {
	["24207"] = true,	-- Army of the Dead
	["29630"] = true,	-- Fanged Pit Viper (Gundrak)
	["55659"] = true,	-- Wild Imp
	["167966"] = true,	-- Experimental Sludge (De Other Side)
}

T.InterruptCast = {
	-- De Other Side
	[332612] = true,	-- Healing Wave
	[332706] = true,	-- Heal
	[332084] = true,	-- Self-Cleaning Cycle
	-- Halls of Atonement
	[325700] = true,	-- Collect Sins
	[323552] = true,	-- Volley of Power
	-- Mists of Tirna Scithe
	[324914] = true,	-- Nourish the Forest
	[321828] = true,	-- Patty Cake
	[326046] = true,	-- Stimulate Resistance
	-- Spires of Ascension
	[327413] = true,	-- Rebellious Fist
	[317936] = true,	-- Forsworn Doctrine
	[327648] = true,	-- Internal Strife
	[328295] = true,	-- Greater Mending
	-- The Necrotic Wake
	[324293] = true,	-- Rasping Scream
	[334748] = true,	-- Drain Fluids
	[323190] = true,	-- Meat Shield
	[320822] = true,	-- Final Bargain
	[338353] = true,	-- Goresplatter
	[327130] = true,	-- Repair Flesh
	-- Theater of Pain
	[342139] = true,	-- Battle Trance
	[330562] = true,	-- Demoralizing Shout
	[342675] = true,	-- Bone Spear
	[341969] = true,	-- Withering Discharge
	[341977] = true,	-- Meat Shield
	[330868] = true,	-- Necrotic Bolt Volley
	-- Plaguefall
	[329239] = true,	-- Creepy Crawlers
	-- Sanguine Depths
	[322433] = true,	-- Stoneskin
}

T.ImportantCast = {
	-- Halls of Atonement
	[326450] = true,	-- Loyal Beasts
	-- Theater of Pain
	[330586] = true,	-- Devour Flesh
	-- Plaguefall
	[328177] = true,	-- Fungistorm
}

local color = C.nameplate.mob_color
local color2 = {0, 0.7, 0.6}
T.ColorPlate = {
	-- Mists of Tirna Scithe
	["164921"] = color,		-- Drust Harvester
	["166299"] = color,		-- Mistveil Tender
	["166275"] = color2,	-- Mistveil Shaper
	["165251"] = color,		-- Illusionary Vulpin
	["167111"] = color,		-- Spinemaw Staghorn
	-- Plaguefall
	["169861"] = color,		-- Ickor Bileflesh
	-- Theater of Pain
	["174210"] = color,		-- Blighted Sludge-Spewer
	-- Halls of Atonement
	["165529"] = color,		-- Depraved Collector
	-- PvP
	["5925"] = color,		-- Grounding Totem
}

T.ShortNames = {
	-- Смертельная тризна
	["Ассистент-расчленитель"] = "Расчленитель",
	["Ассистент-сшиватель"] = "Сшиватель",
	["Верное создание"] = "Создание",
	["Возрожденный арбалетчик"] = "Арбалетчик",
	["Возрожденный воин"] = "Воин",
	["Запасные части"] = "Запчасти",
	["Изготовитель кадавров"] = "Изготовитель",
	["Кирийский кадавр"] = "Кадавр",
	["Костоправ с \"Золрамуса\""] = "Костоправ",
	["Костяное чудовище"] = "Чудовище",
	["Куски Кровомеса"] = "Куски",
	["Лоскутный солдат"] = "Солдат",
	["Мрачный колосс"] = "Колосс",
	["Налтор Криомант"] = "Налтор",
	["Некромант с \"Золрамуса\""] = "Некромант",
	["Оживленный маг"] = "Маг",
	["Останки Тошногнила"] = "Останки",
	["Похитительница с \"Золрамуса\""] = "Похитительница",
	["Резчик с \"Золрамуса\""] = "Резчик",
	["Сборщик трупов"] = "Сборщик",
	["Скелет-мародер"] = "Мародер",
	["Собиратель трупов"] = "Собиратель",
	["Создание Трупошва"] = "Создание",
	["Сшитый боец авангарда"] = "Боец",
	["Хранитель врат с \"Золрамуса\""] = "Хранитель",
	["Хрупкий арбалетчик"] = "Арбалетчик",
	["Хрупкий воин"] = "Воин",
	["Хрупкий маг"] = "Маг",
	["Чародей с \"Золрамуса\""] = "Чародей",
	["Червь-трупоед"] = "Трупоед",
	["Чумной мешок"] = "Мешок",
	["Шаркающий труп"] = "Труп",

	-- Шпили Перерождения
	["Голиаф раскольников"] = "Голиаф",
	["Кирийский темный претор"] = "Претор",
	["Раскольник - боец авангарда"] = "Боец",
	["Раскольница - боец авангарда"] = "Боец",
	["Раскольник-бунтарь"] = "Бунтарь",
	["Раскольник-защитник"] = "Защитник",
	["Раскольница-защитник"] = "Защитник",
	["Раскольник-налетчик"] = "Налетчик",
	["Раскольница-налетчик"] = "Налетчик",
	["Раскольник-офицер"] = "Офицер",
	["Раскольница-офицер"] = "Офицер",
	["Раскольник-узурпатор"] = "Узурпатор",
	["Раскольник-хранитель"] = "Хранитель",
	["Раскольник-целитель"] = "Целитель",
	["Раскольница-бичевательница"] = "Бичевательница",
	["Раскольница-инквизитор"] = "Инквизитор",
	["Раскольница-юстициарий"] = "Юстициарий",
	["Сломанный опустошитель"] = "Опустошитель",
	["Стальной коготь раскольников"] = "Коготь",
	["Эфирный Ныряльщик"] = "Ныряльщик",

	-- Театр Боли
	["Адвент Невермор"] = "Адвент",
	["Дессия Обезглавливательница"] = "Дессия",
	["Боевой жнец"] = "Жнец",
	["Боевой ритуалист"] = "Ритуалист",
	["Вестник смерти"] = "Вестник",
	["Гнилостный мясник"] = "Мясник",
	["Докигг Изверг"] = "Докигг",
	["Древний капитан"] = "Капитан",
	["Зараженный ужас"] = "Ужас",
	["Ксав Несломленный"] = "Ксав",
	["Костяной чародей"] = "Чародей",
	["Мордрета, Вечная императрица"] = "Мордрета",
	["Непреклонный соперник"] = "Соперник",
	["Нектара Изувер"] = "Нектара",
	["Отвратительные отходы"] = "Отходы",
	["Пакиран Заразный"] = "Пакиран",
	["Покрытый оссеином рядовой"] = "Рядовой",
	["Призрачный претендент"] = "Претендент",
	["Рек Закаленная"] = "Рек",
	["Сатель Злосчастный"] = "Сатель",
	["Скованная душа"] = "Душа",
	["Сочащиеся ошметки"] = "Ошметки",
	["Чумной изрыгатель слизи"] = "Изрыгатель",
	["Шаркающий арбалетчик"] = "Арбалетчик",
	["Яростный кроворог"] = "Кроворог",
	["Тошнотворный газовый мешок"] = "Мешок",
	["Страж портала"] = "Страж",
	["Маниакальный стражник душ"] = "Стражник",
	["Пагубный темный проповедник"] = "Проповедник",
	["Усиленный душами похититель костей"] = "Похититель",
	["Харугия Кровожадная"] = "Харугия",
	["Хивин Ломатель"] = "Хивин",

	-- Чумные каскады
	["Домина Отравленный Клинок"] = "Домина",
	["Болотный солдат"] = "Солдат",
	["Болотный шершень"] = "Шершень",
	["Жалкий чумной бурильщик"] = "Бурильщик",
	["Взрывоопасный чумной бурильщик"] = "Бурильщик",
	["Вирулакс Заклинатель Чумы"] = "Вирулакс",
	["Гниющий слизнекоготь"] = "Слизнекоготь",
	["Гриб-штурмовик"] = "Штурмовик",
	["Заклинатель чумы"] = "Заклинатель",
	["Заразный добытчик"] = "Добытчик",
	["Защитник из многоокой рати"] = "Защитник",
	["Извергающаяся слизь"] = "Слизь",
	["Изрыгатель чумы"] = "Изрыгатель",
	["Икор Желчная Плоть"] = "Икор",
	["Костномозговая слизь"] = "Слизь",
	["Крадущийся паучок"] = "Паучок",
	["Маленький болотный шершень"] = "Шершень",
	["Маркграфиня Страдама"] = "Страдама",
	["Мерзкая вкусняшка"] = "Вкусняшка",
	["Мерзкий ползун"] = "Ползун",
	["Моровая слизь"] = "Слизь",
	["Нестабильная канистра"] = "Канистра",
	["Нестабильная личинка"] = "Личинка",
	["Нестабильная чумная бомба"] = "Бомба",
	["Осклизлое лакомство"] = "Лакомство",
	["Пикантные пальчики"] = "Пальчики",
	["Паук-убийца"] = "Паук",
	["Ползучая слизь"] = "Слизь",
	["Разлагающийся великан"] = "Великан",
	["Расчленяемый десерт"] = "Десерт",
	["Сгусток слизи"] = "Сгусток",
	["Склизкое щупальце"] = "Щупальце",
	["Сочный окорок"] = "Окорок",
	["Стрелок-отравитель"] = "Стрелок",
	["Таящийся паук"] = "Паук",
	["Тлетворное порождение"] = "Порождение",
	["Хлещущая слизь"] = "Слизь",
	["Чумная бомба"] = "Бомба",
	["Чумная падшая воительница"] = "Воительница",
	["Чумная прислужница"] = "Прислужница",
	["Чумное гнездо"] = "Гнездо",
	["Чумной бурильщик"] = "Бурильщик",
	["Чумной рух"] = "Рух",
	["Чумной спинолом"] = "Спинолом",
	["Ядовитый паук"] = "Паук",

	-- Туманы Тирна Скитта
	["Друст - злобный коготь"] = "Коготь",
	["Друст-древолом"] = "Древолом",
	["Друст-душеруб"] = "Душеруб",
	["Друст-жнец"] = "Жнец",
	["Жительница Тирна Скитта"] = "Жительница",
	["Жоробрюх Туманной Завесы"] = "Жоробрюх",
	["Иглобрюх-кислотник"] = "Кислотник",
	["Иглобрюх-поглотитель"] = "Поглотитель",
	["Иглобрюх-разоритель"] = "Разоритель",
	["Иглобрюх-рогач"] = "Рогач",
	["Иллюзорный клон"] = "Клон",
	["Иллюзорный лисохвост"] = "Лисохвост",
	["Личинка горма"] = "Личинка",
	["Личинка иглобрюха"] = "Личинка",
	["Матриарх темнокрылов"] = "Матриарх",
	["Ночноцвет Туманной Завесы"] = "Ночноцвет",
	["Опутывающие заросли"] = "Заросли",
	["Призывательница Туманов"] = "Призывательница",
	["Разросшаяся гидра"] = "Гидра",
	["Туманная защитница"] = "Защитница",
	["Туманная хранительница"] = "Хранительница",
	["Туманный культиватор"] = "Культиватор",
	["Туманный острожал"] = "Острожал",
	["Туманный страж"] = "Страж",
	["Туманный хищник"] = "Хищник",

	-- Та Сторона
	["Агрессивный мечеклюв"] = "Мечеклюв",
	["Безголовый клиент"] = "Клиент",
	["Верный служитель из племени Атал'ай"] = "Служитель",
	["Верная служительница из племени Атал'ай"] = "Служительница",
	["Вестник смерти"] = "Вестник",
	["Вестник смерти из племени Атал'ай"] = "Вестник",
	["Вестница смерти из племени Атал'ай"] = "Вестница",
	["Воскрешенный полководец"] = "Полководец",
	["Восставший сектант"] = "Сектант",
	["Дух вестника смерти из племени Атал'ай"] = "Дух",
	["Испорченная бормашина"] = "Бормашина",
	["Мейкот, страж кладки"] = "Мейкот",
	["Мечеклюв-матриарх"] = "Матриарх",
	["Мифреш Небесный Коготь"] = "Мифреш",
	["Молодой рунический олень"] = "Олень",
	["Нестабильное воспоминание"] = "Воспоминание",
	["Оживленный костяной воин"] = "Воин",
	["Проклинатель худу из племени Атал'ай"] = "Проклинатель",
	["Проклинательница худу из племени Атал'ай"] = "Проклинательница",
	["Птенец мечеклюва"] = "Птенец",
	["Разумное масло"] = "Масло",
	["Разъяренный дух"] = "Дух",
	["Расколотое видение"] = "Видение",
	["Рунический старорог"] = "Старорог",
	["Скелет-ящер"] = "Ящер",
	["Спригган - заклинатель коры"] = "Заклинатель",
	["Спригган - подчинитель разума"] = "Подчинитель",
	["Старший жрец из племени Атал'ай"] = "Жрец",
	["Старшая жрица из племени Атал'ай"] = "Жрица",
	["Хаккар Свежеватель Душ"] = "Хаккар",
	["Чащобный мерцающий мотылек"] = "Мотылек",
	["Яростная маска"] = "Маска",
	["Миллифисент Манашторм"] = "Миллифисент",
	["Миллхаус Манашторм"] = "Миллхаус",

	-- Кровавые катакомбы
	["Аристократ-дуэлянт"] = "Дуэлянт",
	["Благородный туманный танцор"] = "Танцор",
	["Вершитель Тарвольд"] = "Тарвольд",
	["Верховная надзирательница Бериллия"] = "Бериллия",
	["Взбесившийся вурдалак"] = "Вурдалак",
	["Гаргон-защитник"] = "Защитник",
	["Главный смотритель Джавлин"] = "Джавлин",
	["Жуткий егерь"] = "Егерь",
	["Зачарованное перо"] = "Перо",
	["Зловещая подавительница"] = "Подавительница",
	["Изголодавшийся клещ"] = "Клещ",
	["Изменчивое воплощение"] = "Воплощение",
	["Кровавый кадет"] = "Кадет",
	["Ненасытный громила"] = "Громила",
	["Ненасытный клещ"] = "Клещ",
	["Оживленное оружие"] = "Оружие",
	["Писец-исследователь"] = "Писец",
	["Писец-исследовательница"] = "Писец",
	["Прожорливый жуткий нетопырь"] = "Нетопырь",
	["Скальный дух"] = "Дух",
	["Старший смотритель"] = "Смотритель",
	["Страж глубин"] = "Страж",
	["Темная прислужница"] = "Прислужница",
	["Тоскующий узник"] = "Узник",
	["Часовой чертогов"] = "Часовой",
	["Чумазый гряземес"] = "Гряземес",
	["Частица неистовства"] = "Частица",
	["Частица сомнений"] = "Частица",
	["Истощенный узник"] = "Узница",

	-- Чертоги Покаяния
	["Верховный адъюдикатор Ализа"] = "Ализа",
	["Верный камнерожденный"] = "Камнерожденный",
	["Воплощение зависти"] = "Воплощение",
	["Жуткий молельщик"] = "Молельщик",
	["Замученная душа"] = "Душа",
	["Инквизитор Зигар"] = "Зигар",
	["Камнерожденная-потрошительница"] = "Потрошительница",
	["Камнерожденный-разоритель"] = "Разоритель",
	["Камнерожденный-рассекатель"] = "Рассекатель",
	["Лорд-камергер"] = "Камергер",
	["Мелкий камнебес"] = "Камнебес",
	["Неумирающий камнебес"] = "Камнебес",
	["Оживленный грех"] = "Грех",
	["Порочная сборщица"] = "Сборщица",
	["Порочный псарь"] = "Псарь",
	["Порочный темный клинок"] = "Клинок",
	["Порочный уничтожитель"] = "Уничтожитель",
	["Работящий смотритель"] = "Смотритель",
	["Свирепый гаргон"] = "Гаргон",
	["Фрагмент Халкиаса"] = "Фрагмент",
}