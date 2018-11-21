/* isSenjata(Nama,Damage). */
isSenjata(ak47,90).
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

/* isAmmo(Nama,BanyakPeluru). */
isAmmo(ak47_ammo,100).
isAmmo(glock_ammo,100).
isAmmo(sniper_rifle_ammo,100).
isAmmo(mp5_ammo,100).
/*-----------------------------*/

/* barang(Id,Nama,X,Y). */
:- dynamic(barang/3).
init_barang :-
    asserta(barang(chainmail,2,3)),
    asserta(barang(ak47_ammo,2,3)),
    asserta(barang(ak47,8,2)),
    asserta(barang(betadine,3,9)),
    asserta(barang(tshirt,1,1)).