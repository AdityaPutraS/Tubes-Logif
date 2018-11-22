:- dynamic(barang/5). /* barang(Id,Nama,X,Y,Atribut) */

/* isSenjata(Nama,Damage). */
isSenjata(ak47,10).
isSenjata(glock,5).
isSenjata(sniper_rifle,15).
isSenjata(mp5,12).
/*-----------------------------*/

/* isArmor(Nama,ArmorPoint). */
isArmor(chainmail,90).
isArmor(ironmail,100).
isArmor(tshirt,2).
/*-----------------------------*/

/* isMedicine(Nama,HealthPoint). */
isMedicine(betadine,25).
isMedicine(salonpas,15).
isMedicine(perban,30).
/*-----------------------------*/

/* isAmmo(Nama,BanyakPeluru,SenjataYangSesuai). */
isAmmo(ak47_ammo,100,ak47).
isAmmo(glock_ammo,100,glock).
isAmmo(sniper_rifle_ammo,100,sniper_rifle).
isAmmo(mp5_ammo,100,mp5).
/*-----------------------------*/

