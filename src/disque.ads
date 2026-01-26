package Disque is
type T_Slot;
type P_Slot is access all T_Slot;
type T_Slot is record
    address : Integer;
    taille : Integer;
    suivant : P_Slot;
end record;
disque_restant : Long_Integer := 1000000000;
origin : aliased T_Slot := (address => 0, taille => 0, suivant => null); 
emplacement_origin : P_Slot := origin'Access;
compteur : Integer := 1;

procedure Creation(slot : out T_Slot ;taille : in Integer);
procedure Destruction(id : Integer);
procedure Modif(id : in Integer; nouvelle_taille : in Integer);
procedure Ajouter_Slot(slot : T_Slot);

function Trouver_Slot(id : Integer) return P_Slot;
function Check_Restant(taille : Integer) return Boolean;

No_Remaining_Place : exception;

end Disque;