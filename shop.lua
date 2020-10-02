--start_new_game()
local width, height = get_window_size()
local page = 1
local hide = 0
local player = {}
local pressed_button = 1
local options = {chat = 0, backgroundclick = 0, name = 0, timer = 0, score = 0, hint = 0, feedback = 0}
local stored_params = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
local qi_requirements = { 'unknown', 0, 500, 10000, 0, 0, 0, 500, 1500, 500, 0, 500, 0, 1000, 0, 500, 2500, 20000, 0, 1000, 15000, 0, 0, 0, 0, 500, 0, 1000, 2000, 1000, 100, 1000, 500, 0, 2000, 0, 2000, 1000, 500, 0, 1000, 0, 0, 1000, 0, 2500, 2000, 10000, 0, 0, 1000, 500, 0, 1000, 0, 0, 500, 1000, 1000, 1000, 5000, 1000, 0, 1000, 2000, 20000, 2000, 1000}
local categories = {'Force', 'Relax', 'Primary gradient', 'Secondary gradient', 'Torso', 'Blood', 'Ghost', 'Right hand motion trail', 'Left hand motion trail', 'Right leg motion trail', 'Left leg motion trail', 'DQ', "User text", "Timer", 'Grip color', 'Emote color', 'Hair color'}
local current_cat = 1
local current_id = 'unknown'
local cat_buttons = {}
local market_button_status = 0
local buy_button_status = 0
local emote_color_id = 0
local grip_color_id = 0
local text_color_id = 0
local timer_color_id = 0
local price_list = {
force = {8000, 26000, 5, 26000, 25000, 1500, 50000, 84000, 10000, 4500, 24000, 25, 26000, 10000, 50000, 84000, 16, 18000, 26000, 3, 1215, 25, 15000, 10000, 21000, 12000, 42000, 84000, 42000, 2100, 50400, 16800, 50000, 84000, 1500, 10500, 63000, 8000, 6000, 60000, 25200, 35, 50000, 45000, 84000, 50000, 3, 27000, 1500, 50400, 16000, 15000, 25000, 2540, 72000, 16800, 54000, 42000, 42000, 15000, 54000, 6000, 84000, 84000, 18, 84000, 63000},
relax = {8000, 13000, 3, 12000, 25000, 1500, 25000, 42000, 5000, 4500, 12000, 25, 13000, 5000, 25000, 42000, 13, 18000, 12000, 2, 1215, 25, 15000, 5000, 10500, 12000, 42000, 42000, 21000, 1050, 25200, 8400, 45000, 42000, 1500, 5250, 31500, 4000, 6000, 30000, 12600, 25, 25000, 45000, 42000, 50000, 2, 27000, 1500, 25200, 8000, 15000, 25000, 2540, 72000, 8400, 27000, 42000, 42000, 15000, 27000, 6000, 42000, 42000, 12, 42000, 31500},
torso = {4400, 15600, 1, 15600, 30000, 500, 30000, 50400, 6000, 5400, 14400, 50, 15600, 6000, 30000, 50400, 1, 21600, 15600, 1, 720, 50, 18000, 6000, 12600, 12000, 50400, 50400, 25200, 2100, 30240, 10080, 'unknown', 50400, 500, 6300, 37800, 2200, 7800, 36000, 15120, 60, 30240, 54000, 50400, 30000, 1, 32400, 800, 30240, 9600, 18000, 30000, 3048, 72000, 10080, 32400, 84000, 50400, 18000, 32400, 3000, 50400, 50400, 1, 50400, 37800},
ghost = {2000, 10200, 2, 9000, 19300, 500, 20000, 32800, 4000, 3500, 9400, 50, 10200, 4000, 19300, 32800, 6, 13900, 9000, 1, 600, 50, 11600, 4000, 8200, 8000, 32400, 32800, 16400, 820, 19680, 6560, 'unknown', 32800, 500, 4100, 24600, 1000, 4500, 23000, 9840, 60, 19680, 34700, 32800, 20000, 'unknown', 20800, 800, 19680, 6400, 19200, 19300, 2000, 48000, 6560, 20800, 32800, 32400, 11600, 21000, 1500, 32800, 32800, 10, 32800, 24600},
dq = {1000, 2200, 1, 3000, 4100, 1000, 4100, 6800, 900, 800, 2000, 15, 2200, 900, 4100, 6800, 2, 3000, 3000, 1, 450, 15, 2500, 800, 1700, 8000, 6800, 6800, 3400, 160, 4080, 1360, 'unknown', 6800, 100, 850, 5100, 500, 1500, 4800, 2040, 10, 4080, 7300, 6800, 4100, 'unknown', 4400, 300, 4080, 1400, 10000, 4100, 500, 48000, 1360, 4400, 6800, 6800, 2500, 4400, 1000, 6800, 6800, 1, 6800, 5100},
trails = {12800, 13000, 1, 20800, 400000, 800, 25000, 42000, 5000, 7200, 12000, 20, 13000, 5000, 30000, 42000, 1, 28800, 20800, 1, 2360, 20, 24000, 5000, 10500, 19200, 12000, 42000, 21000, 1050, 25200, 8400, 'unknown', 42000, 800, 5250, 31500, 6400, 5200, 30000, 12600, 36, 25000, 72000, 42000, 25000, 1, 43200, 2400, 25200, 8000, 56000, 28000, 4080, 115200, 8400, 43200, 12000, 67200, 24000, 27000, 12800, 42000, 67200, 1, 42000, 31500},
grad = {8000, 13000, 2, 13000, 25000, 500, 25000, 42000, 5000, 4500, 12000, 12, 13000, 5000, 25000, 42000, 1, 18000, 13000, 1, 1475, 12, 15000, 5000, 10500, 8000, 42000, 42000, 21000, 1050, 25200, 8400, 'unknown', 42000, 500, 5250, 31500, 4000, 6500, 30000, 12600, 23, 25000, 45000, 42000, 25000, 1, 27000, 1500, 25200, 8000, 30000, 25500, 2550, 48000, 8400, 27000, 42000, 42000, 15000, 27000, 8000, 42000, 42000, 2, 42000, 31500},
blood = {16000, 26000, 3, 50000, 50000, 1000, 50000, 84000, 10000, 9000, 24000, 25, 26000, 10000, 50000, 84000, 10, 36000, 26000, 1, 2950, 25, 30000, 10000, 21000, 24000, 84000, 84000, 42000, 2100, 50400, 16800, 40000, 84000, 1000, 10500, 63000, 8000, 13000, 60000, 25200, 70, 50000, 90000, 84000, 50000, 1, 54000, 3000, 50400, 16000, 30000, 50000, 5100, 144000, 16800, 54000, 84000, 84000, 30000, 54000, 16000, 84000, 84000, 20, 84000, 63000},
gui = {6400, 10400, 1, 10400, 20000, 400, 20000, 33600, 4000, 3600, 9600, 10, 10400, 4000, 20000, 33600, 1, 14400, 10400, 1, 1180, 10, 12000, 4000, 8400, 15000, 6000, 33600, 16800, 840, 20160, 6720, 'unknown', 33600, 400, 4200, 25200, 3200, 5200, 24000, 10080, 18, 20200, 36000, 33600, 20000, 1, 21600, 1200, 20160, 6400, 2800, 20000, 2040, 90000, 6720, 21600, 6000, 33600, 6000, 21600, 6400, 33600, 6000, 1, 33600, 25200},
hair = {16000, 50000, 50000, 50000, 50000, 1000, 50000, 50000, 50000, 9000, 50000, 25, 50000, 50000, 50000, 50000, 300000, 36000, 50000, 1500, 5900, 25, 30000, 50000, 50000, 50000, 15000, 50000, 50000, 50000, 50000, 50000, 'unknown', 50000, 1000, 50000, 50000, 50000, 26000, 50000, 'unknown', 45, 50000, 90000, 50000, 50000, 1500, 54000, 3000, 50000, 50000, 7000, 50000, 5100, 50000, 50000, 50000, 15000, 84000, 15000, 50000, 50000, 50000, 50000, 10, 50000, 50000},
grip = {4000, 7800, 1, 6500, 12500, 250, 25000, 25000, 3000, 2250, 7200, 6, 7800, 3000, 12500, 25000, 1, 9000, 6500, 1, 700, 6, 7500, 3000, 6250, 6000, 3750, 25000, 12500, 625, 15000, 5000, 'unknown', 25000, 250, 3125, 18750, 2000, 3250, 17800, 7500, 11, 15000, 22500, 25000, 20000, 1, 13500, 750, 15000, 4800, 1750, 12500, 1275, 36000, 5000, 13500, 3750, 21000, 3750, 16000, 4000, 25000, 3750, 1, 25000, 18750}
}
local link_id = {
blood = {44, 828, 1208, 702, 41, 35, 844, 579, 860, 38, 1031, 81, 812, 876, 687, 1290, 70, 74, 638, 143, 84, 87, 43, 1047, 1141, 1576, 496, 780, 1015, 1371, 1240, 1355, 1892, 983, 42, 1156, 1322, 622, 40, 1486, 1256, 36, 1173, 90, 796, 750, 146, 39, 69, 1224, 892, 73, 562, 93, 1592, 1339, 671, 534, 45, 500, 999, 37, 1125, 655, 606, 967, 1306},
force = {59, 830, 1206, 705, 65, 49, 846, 581, 862, 55, 1033, 82, 814, 878, 689, 1292, 71, 79, 640, 144, 85, 88, 57, 1049, 1143, 1578, 205, 782, 1017, 1373, 1238, 1357, 1895, 985, 47, 1159, 1324, 624, 63, 1489, 1254, 51, 1176, 91, 798, 752, 148, 61, 77, 1222, 894, 75, 565, 94, 1594, 1341, 673, 533, 67, 498, 1001, 53, 1127, 657, 608, 969, 1308},
relax = {60, 836, 1214, 711, 66, 50, 852, 587, 868, 56, 1039, 83, 820, 884, 695, 1298, 72, 80, 646, 145, 86, 89, 58, 1055, 1149, 1584, 495, 788, 1023, 1379, 1246, 1363, 1894, 991, 48, 1165, 1330, 630, 64, 1495, 1262, 52, 1182, 92, 804, 758, 147, 62, 78, 1230, 900, 76, 571, 95, 1600, 1347, 679, 532, 68, 499, 1007, 54, 1133, 663, 614, 975, 1314},
torso = {124, 841, 1219, 716, 125, 126, 857, 592, 873, 127, 1044, 128, 825, 889, 700, 1303, 201, 129, 651, 1069, 130, 131, 132, 1060, 1154, 1589, 497, 793, 1028, 1384, 1251, 1368, 'unknown', 996, 133, 1170, 1335, 635, 134, 1500, 1267, 135, 1187, 136, 809, 763, 149, 137, 138, 1235, 905, 139, 576, 140, 1605, 1352, 684, 531, 141, 501, 1012, 142, 1138, 668, 619, 980, 1319},
ghost = {152, 831, 1205, 706, 153, 154, 847, 582, 863, 155, 1034, 156, 815, 879, 690, 1293, 157, 158, 641, 159, 160, 161, 162, 1050, 1144, 1579, 163, 783, 1018, 1374, 1237, 1358, 'unknown', 986, 164, 1160, 1325, 625, 165, 1490, 1253, 166, 1177, 167, 799, 753, 'unknown', 168, 169, 1221, 895, 170, 566, 171, 1595, 1342, 674, 172, 173, 174, 1002, 175, 1128, 658, 609, 970, 1309},
dq = {176, 827, 1209, 703, 177, 178, 843, 578, 859, 179, 1030, 180, 811, 875, 686, 1289, 181, 182, 637, 183, 184, 185, 186, 1046, 1140, 1575, 187, 779, 1014, 1370, 1241, 1354, 'unknown', 982, 188, 1157, 1321, 621, 189, 1487, 1257, 190, 1174, 191, 795, 749, 'unknown', 192, 193, 1225, 891, 194, 563, 195, 1591, 1338, 670, 196, 197, 198, 998, 199, 1124, 654, 605, 966, 1305},
timer = {272, 840, 1218, 715, 273, 274, 856, 591, 872, 275, 1043, 276, 824, 888, 699, 1302, 277, 278, 650, 279, 280, 281, 282, 1059, 1153, 1588, 283, 792, 1027, 1383, 1250, 1367, 'unknown', 995, 284, 1169, 1334, 634, 285, 1499, 1266, 286, 1186, 287, 808, 762, 288, 289, 290, 1234, 904, 291, 575, 292, 1604, 1351, 683, 293, 294, 295, 1011, 296, 1137, 667, 618, 979, 1318},
rhmt = {351, 837, 1215, 712, 352, 353, 853, 588, 869, 354, 1040, 367, 821, 885, 696, 1299, 355, 356, 647, 357, 368, 369, 358, 1056, 1150, 1585, 370, 789, 1024, 1380, 1247, 1364, 'unknown', 992, 359, 1166, 1331, 631, 360, 1496, 1263, 361, 1183, 371, 805, 759, 375, 362, 363, 1231, 901, 364, 572, 372, 1601, 1348, 680, 373, 365, 374, 1008, 366, 1134, 664, 615, 976, 1315},
lhmt = {401, 833, 1211, 708, 402, 403, 849, 584, 865, 404, 1036, 417, 817, 881, 692, 1295, 405, 406, 643, 407, 418, 419, 408, 1052, 1146, 1581, 420, 785, 1020, 1376, 1243, 1360, 'unknown', 988, 409, 1162, 1327, 627, 410, 1492, 1259, 411, 1179, 421, 801, 755, 425, 412, 413, 1227, 897, 414, 568, 422, 1597, 1344, 676, 423, 415, 424, 1004, 416, 1130, 660, 611, 972, 1311},
rlmt = {426, 838, 1216, 713, 427, 428, 854, 589, 870, 429, 1041, 442, 822, 886, 697, 1300, 430, 431, 648, 432, 443, 444, 433, 1057, 1151, 1586, 445, 790, 1025, 1381, 1248, 1365, 'unknown', 993, 434, 1167, 1332, 632, 435, 1497, 1264, 436, 1184, 446, 806, 760, 450, 437, 438, 1232, 902, 439, 573, 447, 1602, 1349, 681, 448, 440, 449, 1009, 441, 1135, 665, 616, 977, 1316},
llmt = {326, 834, 1212, 709, 327, 328, 850, 585, 866, 329, 1037, 342, 818, 882, 693, 1296, 330, 331, 644, 332, 343, 344, 333, 1053, 1147, 1582, 345, 786, 1021, 1377, 1244, 1361, 'unknown', 989, 334, 1163, 1328, 628, 335, 1493, 1260, 336, 1180, 346, 802, 756, 350, 337, 338, 1228, 898, 339, 569, 347, 1598, 1345, 677, 348, 340, 349, 1005, 341, 1131, 661, 612, 973, 1312},
grip = {506, 832, 1210, 707, 507, 508, 848, 583, 864, 509, 1035, 522, 816, 880, 691, 1294, 510, 511, 642, 512, 523, 524, 513, 1051, 1145, 1580, 525, 784, 1019, 1375, 1242, 1359, 'unknown', 987, 514, 1161, 1326, 626, 515, 1491, 1258, 516, 1178, 526, 800, 754, 530, 517, 518, 1226, 896, 519, 567, 527, 1596, 1343, 675, 528, 520, 529, 1003, 521, 1129, 659, 610, 971, 1310},
text = {460, 842, 1220, 717, 461, 462, 858, 593, 874, 463, 1045, 476, 826, 890, 701, 1304, 464, 465, 652, 466, 477, 478, 467, 1061, 1155, 1590, 479, 794, 1029, 1385, 1252, 1369, 'unknown', 997, 468, 1171, 1336, 636, 469, 1501, 1268, 470, 1188, 480, 810, 764, 484, 471, 472, 1236, 906, 473, 577, 481, 1606, 1353, 685, 482, 474, 483, 1013, 475, 1139, 669, 620, 981, 1320},
emote = {536, 829, 1207, 704, 537, 538, 845, 580, 861, 539, 1032, 552, 813, 877, 688, 1291, 540, 541, 639, 542, 553, 554, 543, 1048, 1142, 1577, 555, 781, 1016, 1372, 1239, 1356, 'unknown', 984, 544, 1158, 1323, 623, 545, 1488, 1255, 546, 1175, 556, 797, 751, 560, 547, 548, 1223, 893, 549, 564, 557, 1593, 1340, 672, 558, 550, 559, 1000, 551, 1126, 656, 607, 968, 1307},
hair = {1755, 1756, 1757, 1758, 1759, 1760, 1761, 1762, 1763, 1764, 1765, 1766, 1767, 1768, 1769, 1770, 1771, 1772, 1773, 1774, 1775, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 1786, 'unknown', 1787, 1788, 1789, 1790, 1791, 1792, 1793, 'unknown', 1794, 1795, 1796, 1797, 1798, 1799, 1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1810, 1811, 1812, 1813, 1814, 1815, 1816, 1817, 1818, 1819},
pg = {219, 835, 1213, 710, 220, 221, 851, 586, 867, 222, 1038, 235, 819, 883, 694, 1297, 223, 224, 645, 225, 236, 237, 226, 1054, 1148, 1583, 238, 787, 1022, 1378, 1245, 1362, 'unknown', 990, 227, 1164, 1329, 629, 228, 1494, 1261, 229, 1181, 239, 803, 757, 243, 230, 231, 1229, 899, 232, 570, 240, 1599, 1346, 678, 241, 233, 242, 1006, 234, 1132, 662, 613, 974, 1313},
sg = {244, 839, 1217, 714, 245, 246, 855, 590, 871, 247, 1042, 260, 823, 887, 698, 1301, 248, 249, 649, 250, 261, 262, 251, 1058, 1152, 1587, 263, 791, 1026, 1382, 1249, 1366, 'unknown', 994, 252, 1168, 1333, 633, 253, 1498, 1265, 254, 1185, 264, 807, 761, 268, 255, 256, 1233, 903, 257, 574, 265, 1603, 1350, 682, 266, 258, 267, 1010, 259, 1136, 666, 653, 978, 1317}
}
local colors = {
{},
{178, 255,  26,  26, 'Acid'},	--Acid
{ 46, 148, 186,  75, 'Adamantium'},	--Adamantium
{ 25,  25, 112, 110, 'Alpha Imperial'},	--Alpha Imperial
{255, 117,  23,  61, 'Amber'},	--Amber
{255,  51, 242,  27, 'Amethyst'},	--Amethyst
{  0, 128, 255,  28, 'Aqua'},	--Aqua
{245, 227, 247,  22, 'Aurora'},	--Aurora
{ 35,  54,  78,  62, 'Azurite'},	--Azurite
{127,  58,   0,  92, 'Beetle'},	--Beetle
{204, 102,  51,  29, 'Bronze'},	--Bronze
{ 85, 107,  47, 101, 'Camo'},	--Camo
{255, 204, 204,  42, 'Chronos'},	--Chronos
{148,   0,   0,  89, 'Cobra'},	--Cobra
{255, 186,  38,  16, 'Copper'},	--Copper
{199,   0,  61,  57, 'Crimson'},	--Crimson
{ 85,  26, 139, 113, 'Demolition'},	--Demo
{ 51,  51,  51,  30, 'Demon'},	--Demon
{255,  51, 230,  31, 'Dragon'},	--Dragon
{ 52, 255, 153,  12, 'Ecto'},	--Ecto
{153,   0, 230,  32, 'Elf'},	--Elf
{140, 115, 166,  43, 'Gaia'},	--Gaia
{191, 166, 128,  44, 'Gladiator'},	--Gladiator
{255, 255,  76,  33, 'Gold'},	--Gold
{152, 251, 152, 123, 'Helios'},	--Helios
{205,  16, 118, 105, 'Hot Pink'},	--Hot Pink
{  0,  53,   0,  95, 'Hunter'},	--Hunter
{178,  76,  76,  45, 'Hydra'},	--Hydra
{  0,  23, 132,  86, 'Imperial'},	--Imperial
{238, 223, 204,  97, 'Ivory'},	--Ivory
{237, 191, 166,  21, 'Juryo'},	--Juryo
{139, 137, 112, 108, 'Kevlar'},	--Kevlar
{139,  95, 101, 121, 'Knox'},	--Knox
{ 46,   0,  15, 128, 'Magma'},
{ 72,  61, 139, 102, 'Magnetite'},	--Magnetite
{ 51,  51, 230,  34, 'Marine'},	--Marine
{154, 192, 205, 109, 'Maya'},	--Maya
{205,  38,  38, 118, 'Mysterio'},	--Mysterio
{ 51, 152, 255,  11, 'Neptune'},	--Neptune
{255, 204,  76,  35, 'Noxious'},	--Noxious
{139, 101,   8, 100, 'Old Gold'},	--Old Gold
{142, 142,  56, 124, 'Olive'},	--Olive
{  0, 128,  26,  36, 'Orc'},	--Orc
{122,  55, 139, 114, 'Persian'},	--Persian
{230, 255, 255,  46, 'Pharos'},	--Pharos
{112, 105, 255,  59, 'Plasma'},	--Plasma
{128, 128, 128,  87, 'Platinum'},	--Platinum
{255, 255, 255,  50, 'Pure'},	--Pure
{204, 204, 204,  37, 'Quicksilver'},	--Quicksilver
{  0, 255, 214,  38, 'Radioactive'},	--Radioactive
{ 16,  78, 139, 106, 'Raider'},	--Raider
{255,  13, 143,  58, 'Raptor'},	--Raptor
{153, 230, 255,  39, 'Sapphire'},	--Sapphire
{140,   0,   0,  65, 'Shaman'},	--Shaman
{255, 255, 128,  47, 'Sphinx'},	--Sphinx
{255, 255,   0,   9, 'Static'},	--Static
{139, 115,  85, 120, 'Superfly'},	--Superfly
{255,   0,   0,  71, 'Supernova'},	--Supernova
{128, 178, 140,  48, 'Titan'},	--Titan
{  0, 255,   0,  40, 'Toxic'},	--Toxic
{166, 255, 255,  49, 'Typhon'},	--Typhon
{139,  58,  98, 107, 'Tyrian'},	--Tyrian
{255,   0,   0,  41, 'Vampire'},	--Vampire
{137,   0, 137, 115, 'Velvet'},	--Velvet
{ 41, 161, 156,  64, 'Viridian'},	--Viridian
{  3,   3,   3,  85, 'Void'},	--Void
{ 47,  79,  79, 104, 'Vulcan'},	--Vulcan
{137, 104, 205, 116, 'Warrior'},	--Warrior
}

local name = get_master().master.nick
local qi = -1

local function get_qi()
    local file = assert(io.open("custom/" .. name .. "/item.dat", 'r', 1))
    local f = 1
    local s = 1
    for i in file:lines() do
        if f <39 then
            f = f+1
        else
            for w in string.gmatch(i, '%d+') do
                if s ~= 2 then
                    s = s+1
                else
                    qi = tonumber(w)
                end
            end
        end
    end
    file:close()
end

local function item_dat()
    local file = assert(io.open("custom/" .. name .. "/item.dat", 'r', 1))
    local f = 1
    local s = 1
    for i in file:lines() do
        if f <3 then
            f = f+1
        else
            for w in string.gmatch(i, '%d+') do
                if s == 9 then
                    timer_color_id = tonumber(w)
                elseif s == 13 then
                    text_color_id = tonumber(w)
                elseif s == 15 then
                    emote_color_id = tonumber(w)
                elseif s == 16 then
                    grip_color_id = tonumber(w)
                end
                s = s+1
            end
        end
    end
    file:close()
end

--[[function item_dat_edit(item, id)
    local file = io.open("custom/" .. name .. "/item.dat", 'r', 1)
    local numbers= {}
    local line = 1
    local s = 1
    local linel = {}
    for i in file:lines() do
        if line == 3 then
            for w in string.gmatch(i, '%d+') do -- нужен фикс
                numbers[s] = w
                s = s+1
            end
            numbers[item] = tostring(id)
            local z = "ITEM " .. numbers[1] .. ";"
            for c = 2, #numbers do
                z = z .. numbers[c] .. " "
            end
            linel[line] = z
        else
            linel[line] = i
        end
        line = line+1
        --echo(i)
    end
    local file2 = io.open("custom/" .. name .. "/item.dat", 'w', 1)
    for i=1,#linel do
        file2:write(linel[i] .. "\n")
    end
    file:close()
    file2:close()
end]]
local function trails_fix()
    local file = assert(io.open("custom/" .. name .. "/item.dat", 'r', 1))
    local numbers= {}
    local line = 1
    local s = 1
    local linel = {}
    for i in file:lines() do
        if line == 11 then
            for w in string.gmatch(i, '%d+') do
                numbers[s] = w
                s = s+1
            end
            for c = 3, #numbers, 2 do
                if numbers[c] == '0' then
                    numbers[c] = '50'
                end
            end
            local z = "TRAILCOL " .. numbers[1] .. ";"
            for c = 2, #numbers do
                z = z .. numbers[c] .. " "
            end
            linel[line] = z
        else
            linel[line] = i
        end
        line = line+1
        --echo(i)
    end
    local file2 = assert(io.open("custom/" .. name .. "/item.dat", 'w', 1))
    for i=1,#linel do
        file2:write(linel[i] .. "\n")
    end
    file:close()
    file2:close()
end

local function init_player()
    --Copypasted from torishop script.
	--local name = get_master().master.nick
	if (name ~= nil) then
		load_player(0, name)	-- use player customs if logged in
        get_qi()
	end
	
	local data1 = set_torishop(0)
	player.blood = data1.blood_color
	player.torso = data1.torso_color
	player.ghost = data1.ghost_color
	player.impact = data1.impact_color
	player.pgrad = data1.grad_pri_color
	player.sgrad = data1.grad_sec_color
	player.lhmt = { data1.lh_trail_r, data1.lh_trail_g, data1.lh_trail_b, data1.lh_trail_a }
	player.rhmt = { data1.rh_trail_r, data1.rh_trail_g, data1.rh_trail_b, data1.rh_trail_a }
	player.llmt = { data1.ll_trail_r, data1.ll_trail_g, data1.ll_trail_b, data1.ll_trail_a }
	player.rlmt = { data1.rl_trail_r, data1.rl_trail_g, data1.rl_trail_b, data1.rl_trail_a }

	local data2 = get_joint_color(0, 0)
	player.relax = data2.joint.relax
	player.force = data2.joint.force
end

local sides = (width-420)%50
local col_in_lines = math.floor((width-sides-420)/50) -- количество столбиков в каждой строке.
local c_buttons = {}

--подсчёт количества страниц с цветами.
if #colors%(col_in_lines*2) ~= 0 then
    pages= math.ceil(#colors / (col_in_lines*2))
else
    pages= math.floor(#colors / (col_in_lines*2))
end

local c_side= 30 --длина сторон цветных кнопок.
local radius=c_side/2 --радиус нажатия.
local close_button_status = 0
local up_arrow_status = 0
local down_arrow_status = 0

local function draw_boxes(c, x, start, d) --отрисовка кнопок с цветами.
    for y = start+1/col_in_lines, start+1, 1/col_in_lines do
        --отрисовка краёв кнопок. (возможно стоит перейти на линии)
        set_color(0,0,0,1)
        draw_quad(quad.pos_x + sides + 50*(x-1)-2, quad.pos_y + 12 + 43*math.floor(y), c_side + 4, c_side + 4)
        --отрисовка кнопок для цветов.
        local xc_button = quad.pos_x + sides + 50*(x-1)
        local yc_button = quad.pos_y + 14 + 43*math.floor(y)
        if d == 1 and c == 1 then
            set_color(1, 1, 1, 1)
            draw_quad(xc_button, yc_button, c_side, c_side)
            set_color(0.9,0,0,1)
            draw_text('x', xc_button+8, yc_button+1, 2)
        else
            set_color(colors[c][1]/255, colors[c][2]/255, colors[c][3]/255,1)
            draw_quad(xc_button, yc_button, c_side, c_side)
        end
        c_buttons[d] = {x = xc_button+radius, y=yc_button+radius} --координаты центра кнопки.
        if c < #colors then
            c = c+1
            x = x+1
            d = d+1
        elseif c > #colors then
            table.remove(c_buttons, d)
        end
    end
end

local function reset_look()
    if categories[current_cat] == 'Force' then
        set_joint_force_color(0, player.force)
    elseif categories[current_cat] == 'Relax' then
        set_joint_relax_color(0, player.relax)
    elseif categories[current_cat] == 'Primary gradient' then
        set_gradient_primary_color(0, player.pgrad)
    elseif categories[current_cat] == 'Secondary gradient' then
        set_gradient_secondary_color(0, player.sgrad)
    elseif categories[current_cat] == 'Torso' then
        set_torso_color(0, player.torso)
    elseif categories[current_cat] == 'Blood' then
        set_blood_color(0, player.blood)
    elseif categories[current_cat] == 'Ghost' then
        set_ghost_color(0, player.ghost)
    elseif categories[current_cat] == 'Left hand motion trail' then
        set_separate_trail_color_2(0, 0, player.lhmt[1], player.lhmt[2], player.lhmt[3], player.lhmt[4])
    elseif categories[current_cat] == 'Right hand motion trail' then
        set_separate_trail_color_2(0, 1, player.rhmt[1], player.rhmt[2], player.rhmt[3], player.rhmt[4])
    elseif categories[current_cat] == 'Left leg motion trail' then
		set_separate_trail_color_2(0, 2, player.llmt[1], player.llmt[2], player.llmt[3], player.llmt[4])
    elseif categories[current_cat] == 'Right leg motion trail' then
		set_separate_trail_color_2(0, 3, player.rlmt[1], player.rlmt[2], player.rlmt[3], player.rlmt[4])
    elseif categories[current_cat] == 'DQ' then
        set_ground_impact_color(0, player.impact)
    --elseif categories[current_cat] == 'User text' then
        --set_usertext_color(0, color_id)
    --elseif categories[current_cat] == 'Hair Color' then
        --set_hair_color(0, color_id)
    end
end

local function set_id()
    if pressed_button > 1 then
        if categories[current_cat] == 'Force' then
            current_id = link_id.force[pressed_button-1]
        elseif categories[current_cat] == 'Relax' then
            current_id = link_id.relax[pressed_button-1]
        elseif categories[current_cat] == 'Primary gradient' then
            current_id = link_id.pg[pressed_button-1]
        elseif categories[current_cat] == 'Secondary gradient' then
            current_id = link_id.sg[pressed_button-1]
        elseif categories[current_cat] == 'Torso' then
            current_id = link_id.torso[pressed_button-1]
        elseif categories[current_cat] == 'Blood' then
            current_id = link_id.blood[pressed_button-1]
        elseif categories[current_cat] == 'Ghost' then
            current_id = link_id.ghost[pressed_button-1]
        elseif categories[current_cat] == 'Left hand motion trail' then
            current_id = link_id.lhmt[pressed_button-1]
        elseif categories[current_cat] == 'Right hand motion trail' then
            current_id = link_id.rhmt[pressed_button-1]
        elseif categories[current_cat] == 'Left leg motion trail' then
		    current_id = link_id.llmt[pressed_button-1]
        elseif categories[current_cat] == 'Right leg motion trail' then
		    current_id = link_id.rlmt[pressed_button-1]
        elseif categories[current_cat] == 'DQ' then
            current_id = link_id.dq[pressed_button-1]
        elseif categories[current_cat] == 'User text' then
            current_id = link_id.text[pressed_button-1]
        elseif categories[current_cat] == 'Hair Color' then
            current_id = link_id.hair[pressed_button-1]
        elseif categories[current_cat] == 'Emote color' then
            current_id = link_id.emote[pressed_button-1]
        elseif categories[current_cat] == 'Timer' then
            current_id = link_id.timer[pressed_button-1]
        elseif categories[current_cat] == 'Grip color' then
            current_id = link_id.grip[pressed_button-1]
        end
    else
        current_id = 'unknown'
    end
end

local function change_look(color_id)
    if categories[current_cat] == 'Force' then
        set_joint_force_color(0, color_id)
    elseif categories[current_cat] == 'Relax' then
        set_joint_relax_color(0, color_id)
    elseif categories[current_cat] == 'Primary gradient' then
        set_gradient_primary_color(0, color_id)
    elseif categories[current_cat] == 'Secondary gradient' then
        set_gradient_secondary_color(0, color_id)
    elseif categories[current_cat] == 'Torso' then
        set_torso_color(0, color_id)
    elseif categories[current_cat] == 'Blood' then
        set_blood_color(0, color_id)
    elseif categories[current_cat] == 'Ghost' then
        set_ghost_color(0, color_id)
    elseif categories[current_cat] == 'Left hand motion trail' then
        set_separate_trail_color(0, 0, color_id)
    elseif categories[current_cat] == 'Right hand motion trail' then
        set_separate_trail_color(0, 1, color_id)
    elseif categories[current_cat] == 'Left leg motion trail' then
		set_separate_trail_color(0, 2, color_id)
    elseif categories[current_cat] == 'Right leg motion trail' then
		set_separate_trail_color(0, 3, color_id)
    elseif categories[current_cat] == 'DQ' then
        set_ground_impact_color(0, color_id)
    elseif categories[current_cat] == 'Emote color' then
        if color_id < 100 then
            run_cmd('em ^' .. color_id .. 'test')
        end
    --[[elseif categories[current_cat] == 'Hair Color' then
        set_hair_color(0, color_id)]]
    end
end

local function switch_page(number)
    if number == 1 then
        if page == pages then
            page = 1
        else
            page = page+1
        end
    elseif number == 0 then
        if page == 1 then
            page = pages
        else
            page = page-1
        end
    end
end

local function close()
	for i, v in pairs(options) do
		set_option(i, 1)
	end
    --[[for i = 1, #categories do
        reset_look(i)
    end]]
    remove_hooks("torishop")
    --start_new_game()
end

local function mouse_down(mouse_btn, x, y)
    if x > 5 and x < 20 and y < 25 then
        close()
    end

    if hide == 1 then
        if x >= 25 and x<=35 and y< 25 then
            hide = 0
        end
    elseif hide == 0 then
        if x >= 25 and  y >=5 and x<=35 and y<=11 then
            hide = 1
        end
        for button = 1, #c_buttons do
            if x < c_buttons[button].x+radius and x > c_buttons[button].x-radius and y < c_buttons[button].y+radius and y > c_buttons[button].y-radius then
                if button == 1 and page == 1 then
                    reset_look(current_cat)
                end
                    for param=1,#stored_params do
                        if param == current_cat then
                            stored_params[param] = button + ((page-1) * col_in_lines * 2)
                            if stored_params[param] <= #colors then
                                pressed_button = stored_params[param]
                            end
                        end
                    end
                set_id()
            end
        end
    
        if (current_id ~= 'unknown' and (y > (height - 109) and y < (height-97) and x > (width - 250) and x < (width - 220))) then
            open_url('http://forum.toribash.com/tori_shop_item.php?id=' .. current_id)
        end
    
        if (current_id ~= 'unknown' and (y > (height - 109) and y < (height-97) and x > (center+60) and x < (center+123))) then
            open_url('http://forum.toribash.com/tori_market.php?action=search&item=' .. current_color_name .. ' ' .. categories[current_cat])
        end
        --цикл для распознавания кнопки завершения.
    
        if x <= center + 30 and x >= center + 10 and y >= height-111 and y <= height - 96 then --кнопка вниз (справа)
            switch_page(1) -- переключиться на следующую страницу
        end
    
        if x <= center -10 and x >= center - 30 and y >= height-112 and y <= height - 97 then --кнопка вверх (слева)
            switch_page(0) -- переключиться на предыдущую страницу
        end
    
        for i = 1, #cat_buttons do --кнопки с категориями итемов
            if x < cat_buttons[i].x+half_width and x > cat_buttons[i].x-half_width and y < cat_buttons[i].y+half_height and y > cat_buttons[i].y-half_height then
                current_cat = i
                if stored_params[i] == 0 then --
                    pressed_button = 1
                else
                    pressed_button = stored_params[i]
                end
                set_id()
            end
        end
        if pressed_button == 1 then
            current_color_name = nil
            current_color_id = nil
        else
            current_color_name = colors[pressed_button][5]
            current_color_id = colors[pressed_button][4]
        end
        change_look(current_color_id)
        if categories[current_cat] == 'DQ' then
            draw_ground_impact(0)
        end
    end
    --цикл для распознавания цветных кнопок.
end

local mouse_on_button = 1
local function mouse_move(x,y)
    if x > 5 and x < 20 and y < 25 then
        close_button_status = 1
    else
        close_button_status = 0
    end

    if hide == 0 then
        if x >= 25 and  y >=5 and x<=35 and y<=11 then
            hide_button_status = 1
        else
            hide_button_status = 0
        end
        if x <= center + 30 and x >= center + 10 and y >= height-111 and y <= height - 96 then
            down_arrow_status = 1
        else
            down_arrow_status = 0
        end
    
        if x <= center -10 and x >= center - 30 and y >= height-112 and y <= height - 97 then
            up_arrow_status = 1
        else
            up_arrow_status = 0
        end
    
        if (current_id ~= 'unknown' and (y > (height - 109) and y < (height-97) and x > (center+60) and x < (center+123))) then
            market_button_status = 1
        else
            market_button_status = 0
        end
    
        if (current_id ~= 'unknown' and (y > (height - 109) and y < (height-97) and x > (width - 250) and x < (width - 220))) then
            buy_button_status = 1
        else
            buy_button_status = 0
        end
    
        for button = 1, #c_buttons do
            if x < c_buttons[button].x+radius and x > c_buttons[button].x-radius and y < c_buttons[button].y+radius and y > c_buttons[button].y-radius then
                mouse_on_button = button + ((page-1) * col_in_lines * 2)
            end
        end
    elseif hide == 1 then
        if x >= 25 and x<=35 and y< 25 then
            unhide_button_status = 1
        else
            unhide_button_status = 0
        end
    end
end

local function draw_categories()
    for i= 1, #categories do
        if i ~= current_cat then
            set_color(0, 0, 0, 0.5)
        else
            set_color(0, 0.3, 0, 0.5)
        end
        draw_quad(6,30+22*i,160,20)
        set_color(0,0,0,1)
        draw_quad(0, 30+22*i, 6,20)
        set_color(0,0,0,1)
        draw_text(categories[i],13, 32+22*i)
        cat_buttons[i] = { x=89, y = 30+22*i+11}
    end
    half_height = 11
    half_width = 77
end

local function draw_arrows(status1, status2)
    set_color(0,0,0,1)
    if status1 == 0 and status2 == 0 then
        draw_disk(center-20, height-101, 0, 10, 3, 1, 60, 360, 0)
        draw_disk(center+20, height-105, 0, 10, 3, 1, 120, 360, 0)
    elseif status1 == 1 then
        draw_disk(center-20, height-101, 5, 10, 3, 1, 60, 360, 0)
        draw_disk(center+20, height-105, 0, 10, 3, 1, 120, 360, 0)
    elseif status2 == 1 then
        draw_disk(center-20, height-101, 0, 10, 3, 1, 60, 360, 0)
        draw_disk(center+20, height-105, 5, 10, 3, 1, 120, 360, 0)
    end
end

local function color_by_id(id)
    for i = 1, #colors do
        if id == colors[i][4] then
            return i
        end
    end
end

local function draw_timer()
    timer_color = stored_params[14]
    if timer_color > 1 then
        set_color(colors[timer_color][1]/255, colors[timer_color][2]/255, colors[timer_color][3]/255, 1)
    elseif timer_color_id == 0 then
        set_color(139/255, 26/255, 26/255, 1)
    else
        local c = color_by_id(text_color_id)
        set_color(colors[c][1]/255, colors[c][2]/255, colors[c][3]/255, 1)
    end
    draw_disk(center, 67, 20, 40, 15, 1, 180, -150, 0) -- имитация таймера
end

local function draw_user_text()
    score = math.ceil(get_player_info(1).injury)
    user_color = stored_params[13]
    if user_color > 1 then
        set_color(colors[user_color][1]/255, colors[user_color][2]/255, colors[user_color][3]/255, 1)
    elseif text_color_id == 0 then
        set_color(139/255, 0, 0, 1)
    else
        local c = color_by_id(text_color_id)
        set_color(colors[c][1]/255, colors[c][2]/255, colors[c][3]/255, 1)
    end
    draw_right_text(score, 10, 25, 0) -- имитация usertext
    draw_right_text(name, 8, 75, 2)
end

local function draw_stuff()
    if hide ~= 1 then
        set_color(colors[3][1]/255, colors[3][2]/255, colors[3][3]/255, 0.7)
        quad = { pos_x= 200, pos_y= height-100, width= width-400, height= 100 } --size of 'colors' window
        draw_quad(quad.pos_x, quad.pos_y, quad.width, quad.height)
        set_color(colors[3][1]/255, colors[3][2]/255, colors[3][3]/255, 1)
        draw_quad(quad.pos_x, height-115, quad.width, 24)
        set_color(0, 0, 0, 1)
        if mouse_on_button ~=1 and mouse_on_button <= #colors then
            draw_text(colors[mouse_on_button][5], quad.pos_x+20, height-112)
        else
            draw_text('', quad.pos_x+20, height-112)
        end
        draw_categories()
        center = width/2
        draw_quad(0, 0, width, 25) -- панель для информации об итеме.
        -- BORDERS
        draw_line(quad.pos_x, height-115, quad.pos_x, height, 2)
        draw_line(quad.pos_x+quad.width, height-115, quad.pos_x+quad.width, height, 2)
        draw_line(quad.pos_x-1, height-115, quad.pos_x+quad.width+1, height-115, 2)
        draw_line(quad.pos_x, height-91, quad.pos_x+quad.width, height-91, 2)
        --
        d=1
        draw_arrows(up_arrow_status, down_arrow_status)
        set_color(1, 1, 1, 1)
        -- Text.
        if type(current_color_name) ~= 'nil' then
            draw_text(current_color_name .. " " .. string.lower(categories[current_cat]), 50, 2)
        else
            draw_text(categories[current_cat] .. " section", 50, 2)
        end

        if qi_requirements[pressed_button] == 0 or (categories[current_cat] == 'Hair color' and current_color_name ~= 'Pure' and current_color_name ~= 'Elf') then
            qi_item_restr = 0
            qi_text = "No QI restriction"
        else
            qi_item_restr = qi_requirements[pressed_button]
            qi_text = "Requires ".. qi_item_restr .. " QI"
        end
        local price = 0
        if (categories[current_cat] ~= 'Hair color' and (current_color_name == 'Pure' or current_color_name == 'Alpha Imperial' or current_color_name == 'Elf' or current_color_name == 'Demon')) or current_color_name == 'Void' then
            payment_method = "USD"
        else
            payment_method = "TC"
        end
        if pressed_button ~=1 then
            if categories[current_cat] == 'Force' then
                price = price_list.force[pressed_button-1]
            elseif categories[current_cat] == 'Relax' then
                price = price_list.relax[pressed_button-1]
            elseif categories[current_cat] == 'Primary gradient' or categories[current_cat] == 'Secondary gradient' then
                price = price_list.grad[pressed_button-1]
            elseif categories[current_cat] == 'Torso' then
                price = price_list.torso[pressed_button-1]
            elseif categories[current_cat] == 'Blood' then
                price = price_list.blood[pressed_button-1]
            elseif categories[current_cat] == 'Ghost' then
                price = price_list.ghost[pressed_button-1]
            elseif categories[current_cat] == 'Left hand motion trail' or categories[current_cat] == 'Right hand motion trail' or categories[current_cat] == 'Left leg motion trail' or categories[current_cat] == 'Right leg motion trail' then
                price = price_list.trails[pressed_button-1]
            elseif categories[current_cat] == 'DQ' then
                price = price_list.dq[pressed_button-1]
            elseif categories[current_cat] == 'Hair color' then
                price = price_list.hair[pressed_button-1]
            elseif categories[current_cat] == 'Grip color' then
                price = price_list.grip[pressed_button-1]
            elseif categories[current_cat] == 'Emote color' or categories[current_cat] == 'User text' or categories[current_cat] == 'Timer' then
                price = price_list.gui[pressed_button-1]
            end
            if price ~= 'unknown' then
                if qi < qi_item_restr then
                    draw_right_text("You don't have enough QI to buy this item. " .. qi_text, 40, 3)
                else
                    draw_right_text(qi_text.."   " .. "Price: " .. price .. " " .. payment_method, 40, 3)
                end
            else
                draw_right_text('This item cannot currently be bought', 40, 3)
            end
        else
            draw_right_text("You've already got this item", 40, 3)
        end
        --'HIDE' BUTTON
        if hide_button_status ~= 0 then
            set_color(0, 0, 0.7, 1)
        end
        draw_line(25, 8, 35, 8, 2)
        --COLOR BUTTONS
        x = 1
        c=1+(page-1)*col_in_lines*2
        draw_boxes(c, x, 0, d) --first line
        c=1+col_in_lines+(page-1)*col_in_lines*2
        d=col_in_lines+1
        draw_boxes(c, x, 1, d) --second line
        -- FAKE STUFF
        draw_user_text()
        draw_timer()
        set_color(0,0,0,1)
        if current_id ~= 'unknown' and qi >= qi_item_restr then
            draw_right_text('BUY', quad.pos_x + 20, height-112)
            draw_text('MARKET', center + 60, height-112)
            if buy_button_status == 1 then
                draw_line(width-quad.pos_x-20, height-95, width-quad.pos_x-51, height-95, 2)
            elseif market_button_status == 1 then
                draw_line(center + 60, height-95, center + 123, height-95, 2)
            end
        end
    else
        set_color(0,0,0,1)
        draw_quad(0, 0, 45, 25)
        set_color(1,1,1,1)
        if unhide_button_status ~= 0 then
            set_color(0, 0, 0.7, 1)
        end
        draw_line(24, 6, 36, 6, 2)
        draw_line(25, 6, 25, 16, 2)
        draw_line(35, 6, 35, 16, 2)
        draw_line(24, 16, 36, 16, 2)
    end
    set_color(1,1,1,1)
    --'CLOSE' BUTTON
    if close_button_status ~= 0 then
        set_color(0.7, 0, 0, 1)
    end
    draw_text('x', 7, 1)
end

for i, v in pairs(options) do
	options[i] = get_option(i)
	set_option(i, v)
end

--[[function key_down(key)
	if (key == string.byte('q')) then
        if hide == 0 then
            hide = 1
        else
            hide = 0
        end
	end
end]]

trails_fix()
init_player()
item_dat()

add_hook('draw2d', 'torishop', draw_stuff)
add_hook("mouse_button_down", "torishop", mouse_down)
add_hook("mouse_move", "torishop", mouse_move)
add_hook('leave_game', 'torishop', close)
--add_hook("key_down", "torishop", key_down)
