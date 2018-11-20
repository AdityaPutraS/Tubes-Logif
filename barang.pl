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

/* isAmmo(Nama,BanyakPeluru). */
isAmmo(ak47_ammo,100).
isAmmo(glock_ammo,100).
isAmmo(sniper_rifle_ammo,100).
isAmmo(mp5_ammo,100).
/*-----------------------------*/

/* barang(Id,Nama,X,Y). */
:- dynamic(barang/4).
init_barang :-
    asserta(barang(1,chainmail,2,3)),
    asserta(barang(2,ak47_ammo,2,3)),
    asserta(barang(3,ak47,8,2)),
    asserta(barang(4,betadine,3,9)),
    asserta(barang(5,tshirt,1,1)).