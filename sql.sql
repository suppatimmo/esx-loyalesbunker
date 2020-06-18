USE `essentialmode`;

CREATE TABLE IF NOT EXISTS `loyales_bunker` (
  `car` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `loyales_bunker` (`car`) VALUES
	('{"extras":[],"modEngine":1,"modXenon":false,"modSpoilers":-1,"wheelColor":147,"modRearBumper":-1,"modDial":-1,"neonEnabled":[false,false,false,false],"wheels":3,"modGrille":-1,"modRoof":-1,"modSteeringWheel":-1,"modDoorSpeaker":-1,"pearlescentColor":0,"plateIndex":1,"modLivery":-1,"modSmokeEnabled":1,"modArchCover":-1,"windowTint":1,"modTrunk":-1,"model":-420911112,"modFrontBumper":-1,"modSideSkirt":-1,"modFender":-1,"modStruts":-1,"modTank":-1,"modBackWheels":-1,"modHydrolic":-1,"modTrimB":-1,"modPlateHolder":-1,"fuelLevel":50.3,"modShifterLeavers":-1,"neonColor":[255,0,255],"modTurbo":false,"modTrimA":-1,"dirtLevel":0.0,"modEngineBlock":-1,"modTransmission":-1,"modSuspension":-1,"bodyHealth":1000.0,"modExhaust":1,"modSeats":-1,"modFrontWheels":17,"modDashboard":-1,"modSpeakers":-1,"plate":"LOYALES","color1":0,"modOrnaments":-1,"modArmor":-1,"modBrakes":-1,"modFrame":-1,"modHorns":-1,"color2":0,"modRightFender":0,"modAerials":-1,"engineHealth":1000.0,"modHood":3,"modWindows":-1,"modAirFilter":-1,"modAPlate":-1,"tyreSmokeColor":[255,255,255],"modVanityPlate":-1}');

CREATE TABLE IF NOT EXISTS `loyales_bunker_depot` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `gunName` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1556 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

CREATE TABLE IF NOT EXISTS `loyales_bunker_magazine` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userID` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `gunName` varchar(10) NOT NULL,
  `gunLabel` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

INSERT INTO `loyales_bunker` (`car`) VALUES
	('{"extras":[],"modEngine":1,"modXenon":false,"modSpoilers":-1,"wheelColor":147,"modRearBumper":-1,"modDial":-1,"neonEnabled":[false,false,false,false],"wheels":3,"modGrille":-1,"modRoof":-1,"modSteeringWheel":-1,"modDoorSpeaker":-1,"pearlescentColor":0,"plateIndex":1,"modLivery":-1,"modSmokeEnabled":1,"modArchCover":-1,"windowTint":1,"modTrunk":-1,"model":-420911112,"modFrontBumper":-1,"modSideSkirt":-1,"modFender":-1,"modStruts":-1,"modTank":-1,"modBackWheels":-1,"modHydrolic":-1,"modTrimB":-1,"modPlateHolder":-1,"fuelLevel":50.3,"modShifterLeavers":-1,"neonColor":[255,0,255],"modTurbo":false,"modTrimA":-1,"dirtLevel":0.0,"modEngineBlock":-1,"modTransmission":-1,"modSuspension":-1,"bodyHealth":1000.0,"modExhaust":1,"modSeats":-1,"modFrontWheels":17,"modDashboard":-1,"modSpeakers":-1,"plate":"LOYALES","color1":0,"modOrnaments":-1,"modArmor":-1,"modBrakes":-1,"modFrame":-1,"modHorns":-1,"color2":0,"modRightFender":0,"modAerials":-1,"engineHealth":1000.0,"modHood":3,"modWindows":-1,"modAirFilter":-1,"modAPlate":-1,"tyreSmokeColor":[255,255,255],"modVanityPlate":-1}');

CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `limit` int(11) NOT NULL DEFAULT '-1',
  `rare` int(11) NOT NULL DEFAULT '0',
  `can_remove` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`) VALUES
	('BKM', 'Bojowy karabin maszynowy (BKM)', 1, 0, 1),
	('chwytBKM', 'Chwyt BKM', 1, 0, 1),
	('kolbaBKM', 'Kolba BKM', 1, 0, 1),
	('KS', 'Karabin snajperski', 1, 0, 1),
	('KSZ', 'Karabin szturmowy', 1, 0, 1),
	('loyalescard', 'Karta magnetyczna Loyales', 5, 0, 1),
	('lufaBKM', 'Lufa BKM', 1, 0, 1),
	('lufaKS', 'Lufa karabinu snajperskiego', 1, 0, 1),
	('lufaKSZ', 'Lufa karabinu szturmowego', 1, 0, 1),
	('lufaPPP', 'Lufa pistoletu przeciwpancernego', 1, 0, 1),
	('lufaRW', 'Lufa rewolweru', 1, 0, 1),
	('lunetaKS', 'Luneta karabinu snajperskiego', 1, 0, 1),
	('magazynekBKM', 'Magazynek BKM', 1, 0, 1),
	('magazynekKSZ', 'Magazynek karabinu szturmowego', 1, 0, 1),
	('magazynekPPP', 'Magazynek pistoletu przeciwpancernego', 1, 0, 1),
	('magazynekSMG', 'Magazynek SMG', 1, 0, 1),
	('mechanizmLADUJACY', 'Mechanizm ładujący', 1, 0, 1),
	('mechanizmTASER', 'Mechanizm paralizatora', 1, 0, 1),
	('mechanizmTLOKOWY', 'Mechanizm tłokowy', 1, 0, 1),
	('PPP', 'Pistolet przeciwpancerny', 1, 0, 1),
	('RW', 'Rewolwer', 1, 0, 1),
	('SMG', 'SMG', 1, 0, 1),
	('ST', 'Strzelba tłokowa', 1, 0, 1),
	('szkieletKS', 'Szkielet karabinu snajperskiego', 1, 0, 1),
	('szkieletKSZ', 'Szkielet karabinu szturmowego', 1, 0, 1),
	('szkieletPPP', 'Szkielet pistoletu przeciwpancernego', 1, 0, 1),
	('szkieletRW', 'Szkielet rewolweru', 1, 0, 1),
	('szkieletSMG', 'Szkielet SMG', 1, 0, 1),
	('szkieletST', 'Szkielet strzelby tłokowej', 1, 0, 1),
	('szkieletTASER', 'Szkielet paralizatora', 1, 0, 1),
	('szpilkaLACZACA', 'Szpilka łącząca', 1, 0, 1),
	('TASER', 'Paralizator', 1, 0, 1),
	('uchwytBKM', 'Uchwyt BKM', 1, 0, 1),
	('uchwytKS', 'Uchwyt karabinu snajperskiego', 1, 0, 1),
	('uchwytKSZ', 'Uchwyt karabinu szturmowego', 1, 0, 1),
	('uchwytRW', 'Uchwyt rewolweru', 1, 0, 1),
	('uchwytSMG', 'Uchwyt SMG', 1, 0, 1),
	('uchwytST', 'Uchwyt strzelby tłokowej', 1, 0, 1),
	('uchwytTASER', 'Uchwyt paralizatora', 1, 0, 1);


