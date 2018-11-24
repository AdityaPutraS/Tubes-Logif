:- dynamic(barang/5). /* barang(Id,Nama,X,Y,Atribut) */

/* isSenjata(Nama,Damage). */
isSenjata(ak47,10).
isSenjata(glock,5).
isSenjata(sniper_rifle,15).
isSenjata(mp5,12).
isSenjata(lasergun, 14).
/*-----------------------------*/

/* isArmor(Nama,ArmorPoint). */
isArmor(chainmail,30).
isArmor(ironmail,60).
isArmor(sacred_cloth, 85).
isArmor(tshirt,2).
/*-----------------------------*/

/* isMedicine(Nama,HealthPoint). */
isMedicine(betadine,25).
isMedicine(salonpas,15).
isMedicine(perban,30).
isMedicine(magic_charm,45).
/*-----------------------------*/

/* isAmmo(Nama,BanyakPeluru,SenjataYangSesuai). */
isAmmo(ak47_ammo,20,ak47).
isAmmo(glock_ammo,30,glock).
isAmmo(sniper_rifle_ammo,10,sniper_rifle).
isAmmo(mp5_ammo,30,mp5).
isAmmo(laser_cartridge,15,lasergun).
/*-----------------------------*/

/* isBag(Nama, Kapasitas). */
isBag(school_bag, 2).
isBag(camping_backpack, 5).
isBag(war_bag, 10).
isBag(light_shoulder_bag, 1).
isBag(travelling_suitcase,4).
