:- dynamic(barang/5). /* barang(Id,Nama,X,Y,Atribut) */

/* isSenjata(Nama,Damage). */
isSenjata(ak47,10).
isSenjata(glock,5).
isSenjata(sniper_rifle,15).
isSenjata(mp5,12).
isSenjata(lasergun, 14).
isSenjata(magic_gun, 20).
/*-----------------------------*/

/* isArmor(Nama,ArmorPoint). */
isArmor(chainmail,20).
isArmor(ironmail,40).
isArmor(sacred_cloth, 50).
isArmor(tshirt,2).
isArmor(royal_dress, 45).
/*-----------------------------*/

/* isMedicine(Nama,HealthPoint). */
isMedicine(betadine,25).
isMedicine(salonpas,15).
isMedicine(perban,30).
isMedicine(magic_charm,45).
isMedicine(mid_heal,60).
/*-----------------------------*/

/* isAmmo(Nama,BanyakPeluru,SenjataYangSesuai). */
isAmmo(ak47_ammo,30,ak47).
isAmmo(glock_ammo,40,glock).
isAmmo(sniper_rifle_ammo,20,sniper_rifle).
isAmmo(mp5_ammo,40,mp5).
isAmmo(laser_cartridge,25,lasergun).
isAmmo(incantation, 5, magic_gun).
/*-----------------------------*/

/* isBag(Nama, Kapasitas). */
isBag(school_bag, 2).
isBag(camping_backpack, 5).
isBag(war_bag, 10).
isBag(light_shoulder_bag, 1).
isBag(travelling_suitcase,4).
