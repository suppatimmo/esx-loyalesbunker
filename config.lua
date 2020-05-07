Config = {}
Config.TimeToProcess = {
        uchwytKSZ = 84,
        uchwytKS = 140,
        uchwytST = 185,
        uchwytRW = 60,
        uchwytSMG = 120,
        uchwytBKM = 130,
        uchwytTASER = 45,
        chwytBKM = 130, 
        magazynekBKM = 130,
        magazynekKSZ = 84,
        magazynekPPP = 75,             
        magazynekSMG = 120,     
        szkieletKSZ = 84,       
        szkieletPPP = 75,              
        szkieletKS = 140,       
        szkieletST = 120,       
        szkieletRW = 85,                        
        szkieletSMG = 120,                      
        szkieletTASER = 60,
        mechanizmTASER = 35,                    
        mechanizmLADUJACY = 140,                         
        mechanizmTLOKOWY = 140,                 
        cylinder = 70,                  
        szpilkaLACZACA = 120,                                            
        lufaKSZ = 84,  
        lufaPPP = 75,  
        lufaKS = 140,   
        lufaBKM = 130,   
        lufaRW = 40,                    
        lunetaKS = 140, 
        doKSZ = 120,            
        doPPP = 75,                     
        doKS = 140,                     
        doST = 120,                     
        doRW = 120,                     
        doSMG = 120,            
        doBKM = 130,    
        doTASER = 60,   
        kolbaBKM = 130,
}
 
Config.GunsProperties = {
        doKSZ = {
                need = { "uchwytKSZ", "szkieletKSZ", "magazynekKSZ", "lufaKSZ" },
                Type = "doKSZ",
                name = "KSZ",
                price = 2500,
        },
        doPPP = { 
                need = { "szkieletPPP", "magazynekPPP", "lufaPPP" },
                Type = "doPPP",
                name = "PPP",
                price = 500,           
        },
        doKS =  {       
                need = { "szkieletKS", "uchwytKS", "lufaKS", "lunetaKS", "mechanizmLADUJACY" },
                Type = "doKS",  
                name = "KS",
                price = 6000,          
        },
        doST =  {       
                need = { "uchwytST", "szkieletST", "mechanizmTLOKOWY", "mechanizmLADUJACY" },
                Type = "doST",  
                name = "ST",
                price = 2000,          
        },
        doRW =  {       
                need = { "uchwytRW", "cylinder", "szkieletRW", "lufaRW" },
                Type = "doRW",
                name = "RW",
                price = 500,           
        },
        doSMG = {
                need = { "szkieletSMG", "szpilkaLACZACA", "uchwytSMG", "magazynekSMG" },
                Type = "doSMG",
                name = "SMG",
                price = 2500,           
        },      
        doBKM = {       
                need = { "uchwytBKM", "kolbaBKM", "magazynekBKM", "lufaBKM", "chwytBKM" },
                Type = "doBKM", 
                name = "BKM",
                price = 5000,          
        },      
        doTASER = {     
                need = { "uchwytTASER", "szkieletTASER", "mechanizmTASER"},
                Type = "doTASER",       
                name = "TASER", 
                price = 200,           
        },
}

Config.WeaponNames = {
	{
		itemName = 'KSZ',
		label = 'Karabin szturmowy'
	},
	{
		itemName = 'PPP',
		label = 'Pistolet przeciwpancerny'
	},
	{
		itemName = 'KS',
		label = 'Karabin snajperski'
	},
	{
		itemName = 'ST',
		label = 'Strzelba tłokowa'
	},
	{
		itemName = 'RW',
		label = 'Rewolwer'
	},
	{
		itemName = 'SMG',
		label = 'SMG'
	},
	{
		itemName = 'BKM',
		label = 'Bojowy karabin maszynowy (BKM)'
	},
	{
		itemName = 'TASER',
		label = 'Paralizator'
	}	
}				
Config.VehPosition = {
    ["x"] = -1484.383851623535, 
    ["y"] = -896.5913964844, 
    ["z"] = 9.084681549072,
	["h"] = 63.06744628906
}

Config.TextPosition = {
    ["x"] = -1484.383851623535, 
    ["y"] = -896.5913964844, 
    ["z"] = 11.084681549072,
}

Config.TeleportPosition = {
    ["x"] = 896.13, 
    ["y"] = -3245.86, 
    ["z"] = -98.25,
}

Config.ExitPosition = {
    ["x"] = 856.99, 
    ["y"] = -3249.46, 
    ["z"] = -99.36,
}

Config.exitTextPosition = {
    ["x"] = 856.99, 
    ["y"] = -3249.46, 
    ["z"] = -97.36,
}

Config.ExitTeleport = {
    ["x"] = -1486.89, 
    ["y"] = -909.50, 
    ["z"] =  10.02,
}
Config.MagazinePosition = {
    ["x"] = 883.07, 
    ["y"] = -3247.43, 
    ["z"] =  -97.28,
}
Config.MagazineTextPosition = {
    ["x"] = 883.07, 
    ["y"] = -3247.43, 
    ["z"] =  -96.28,
}
Config.CarSpawnPosition = {
    ["x"] = 883.26, 
    ["y"] = -3240.10, 
    ["z"] =  -99.28,
}
Config.CarSpawnTextPosition = {
    ["x"] = 883.26, 
    ["y"] = -3240.10, 
    ["z"] =  -97.28,
}
Config.AutoExitPosition = {
    ["x"] = 893.68, 
    ["y"] = -3246.01, 
    ["z"] =  -99.26,
}
Config.AutoExitTextPosition = {
    ["x"] = 893.68, 
    ["y"] = -3246.01, 
    ["z"] =  -97.26,
}
Config.ComputerLocation = {
    ["x"] = 908.54, 
    ["y"] = -3207.10, 
    ["z"] =  -98.19,
}
Config.ComputerTextLocation = {
    ["x"] = 908.54, 
    ["y"] = -3207.10, 
    ["z"] =  -96.19,
} 
Config.clothMenuLocation = {
    ["x"] = -2674.83, 
    ["y"] = 1304.29, 
    ["z"] =  151.01,
}
Config.IllegalSellPosition = {
    ["x"] = 218.95, 
    ["y"] = 2800.63, 
    ["z"] =  44.84,
}
Config.IllegalSellTextPosition = {
    ["x"] = 218.95, 
    ["y"] = 2800.63, 
    ["z"] =  45.84,
}
Config.CardCreatingPosition = {
    ["x"] = -2674.23, 
    ["y"] = 1333.53, 
    ["z"] = 143.26,
}
Config.Bunkers = {
	{
		["x"] = 2488.12,
		["y"] = 3162.6,
		["z"] = 48.78,
	},
	{
		["x"] = 493.96,
		["y"] = 3015.32,
		["z"] = 41.06,
	},	
	{
		["x"] = 2107.75,
		["y"] = 3324.69,
		["z"] = 45.37,
	},	
	{
		["x"] = 850.10,
		["y"] = 3022.81,
		["z"] = 41.28,
	},	
	{
		["x"] = -388.89,
		["y"] = 4336.18,
		["z"] = 56.02,
	},	
	{
		["x"] = 1799.71,
		["y"] = 4705.49,
		["z"] = 39.88,
	},	
	{
		["x"] = -3029.61,
		["y"] = 3333.83,
		["z"] = 10.06,
	}
}
Config.WeaponShopsCarStop = {
	{
		["x"] = 821.75,
		["y"] = -2145.05,
		["z"] = 27.72,
	},
	{
		["x"] = 1687.45,
		["y"] = 3752.04,
		["z"] = 33.20,
	},
	{
		["x"] = -341.10,
		["y"] = 6101.98,
		["z"] = 30.36,
	},
	{
		["x"] = 237.61,
		["y"] = -41.43,
		["z"] = 68.74,
	},
	{
		["x"] = -7.14,
		["y"] = -1109.35,
		["z"] = 27.77,
	},
	{
		["x"] = 2582.26,
		["y"] = 288.03,
		["z"] = 107.46,
	},
	{
		["x"] = -1122.73,
		["y"] = 2715.60,
		["z"] = 17.85,
	},
	{
		["x"] = 846.35,
		["y"] = -1016.45,
		["z"] = 27.03,
	},
}
Config.Markers = {
-- stol 1 - 1 stanowisko
	{
		["x"] = 904.61, 
		["y"] = -3230.31, 
		["z"] = -98.29,
		["type"] = "stol",
	},
-- stol 1 - 2 stanowisko	
	{
		["x"] = 907.01, 
		["y"] = -3230.36, 
		["z"] = -98.29,
		["type"] = "stol",		
	},
-- stol 2	
	{
		["x"] = 909.62, 
		["y"] = -3222.37, 
		["z"] = -98.27,
		["type"] = "stol",		
	},
-- stol 3
	{
		["x"] = 899.31, 
		["y"] = -3224.23, 
		["z"] = -98.27,
		["type"] = "stol",		
	},
-- stol 4 -- 1 stanowisko
	{
		["x"] = 977.83, 
		["y"] = -3221.38, 
		["z"] = -98.25,
		["type"] = "stol",		
	},
-- stol 4 -- 2 stanowisko
	{
		["x"] = 898.12, 
		["y"] = -3221.53, 
		["z"] = -98.25,
		["type"] = "stol",		
	},	
-- stol 5 - 1 stanowisko
	{
		["x"] = 896.46, 
		["y"] = -3218.35, 
		["z"] = -98.23,
		["type"] = "stol",		
	},
-- stol 5 - 2 stanowisko
	{
		["x"] = 897.35, 
		["y"] = -3216.79, 
		["z"] = -98.23,
		["type"] = "stol",		
	},
-- stol 6
	{
		["x"] = 907.83, 
		["y"] = -3211.39, 
		["z"] = -98.22,
		["type"] = "stol",		
	},
-- stol 7
	{
		["x"] = 909.79, 
		["y"] = -3210.52, 
		["z"] = -98.22,
		["type"] = "stol",		
	},
-- stol 8 - 1 stanowisko
	{
		["x"] = 884.47, 
		["y"] = -3200.85, 
		["z"] = -98.20,
		["type"] = "stol",		
	},
-- stol 8 - 2 stanowisko
	{
		["x"] = 885.73, 
		["y"] = -3199.19, 
		["z"] = -98.20,
		["type"] = "stol",		
	},
-- wiertarka stolowa
	{
		["x"] = 888.67, 
		["y"] = -3207.24, 
		["z"] = -98.20,
		["type"] = "wiertarka",		
	},
-- frezarka
	{
		["x"] = 884.02, 
		["y"] = -3207.50, 
		["z"] = -98.20,
		["type"] = "frezarka",		
	},
-- stol z dokumentami
	{
		["x"] = 884.95, 
		["y"] = -3203.26, 
		["z"] = -98.20,
		["type"] = "dokumenty",		
	},
-- tokarka
	{
		["x"] = 892.08, 
		["y"] = -3197.24, 
		["z"] = -98.20,
		["type"] = "tokarka",		
	},
-- duza wiertarka
	{
		["x"] = 887.41, 
		["y"] = -3209.61, 
		["z"] = -98.20,
		["type"] = "duzawiertarka",		
	},
}