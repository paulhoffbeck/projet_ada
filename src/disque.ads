package Disque is

--CONTRATS A FAIRE

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

procedure Creation(slot : out T_Slot ; taille : in Integer);
-- pre  : taille > 0
-- post : slot initialisé avec la taille spécifiée

procedure Destruction(id : Integer);
-- pre  : id correspond à un slot existant
-- post : slot supprimé, mémoire libérée

procedure Modif(id : in Integer; nouvelle_taille : in Integer);
-- pre  : id correspond à un slot existant, nouvelle_taille > 0
-- post : slot modifié avec la nouvelle taille

procedure Ajouter_Slot(slot : T_Slot);
-- pre  : slot valide
-- post : slot ajouté à la liste de gestion mémoire

function Trouver_Slot(id : Integer) return P_Slot;
-- pre  : id > 0
-- post : retourne le pointeur du slot correspondant ou null si inexistant

function Check_Restant(taille : Integer) return Boolean;
-- pre  : taille > 0
-- post : retourne vrai si espace libre suffisant pour taille, sinon faux

No_Remaining_Place : exception;

end Disque;