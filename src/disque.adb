with Disque;
with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;
with Ada.Unchecked_Deallocation;

package body Disque is
   procedure Free is new Ada.Unchecked_Deallocation(T_Slot, P_Slot);

   procedure Creation(slot : out T_Slot ; taille : in Integer) is --procédure permettant de créer un slot de mémoire lors de la création d'un élément
   
   --vérifie la taille restante
   place : Boolean := Check_Restant (taille);
   begin
      -- si il reste de la place on initialise le slot et on l'ajoute à la liste chainée avec la méthode ajouter_slot
      if place then
         slot.address := compteur;
         slot.taille := taille;
         Ajouter_Slot (slot);


         -- on enlève la taille du fichier du disque afin de ne pas le surcharger
         disque_restant := disque_restant - Long_Integer(taille);
         compteur := compteur + 1;
      else
         Put_Line("Espace insuffisant !");
      end if;
   end Creation;

   procedure Ajouter_Slot(slot : in T_Slot) is -- procédure permettant d'ajouter un slot à la liste des slots quand celui-ci est utilisé
   Actuel : P_Slot := emplacement_origin;
   begin
      -- on parcours toute la chaine jusqu'à la fin et on ajoute à la fin un pointeur vers notre nouveau Slot
      while Actuel.all.suivant /= null loop
         Actuel := Actuel.all.suivant;
      end loop;
      Actuel.all.suivant := new T_Slot'(slot);
   end Ajouter_Slot;

   procedure Destruction(id : in Integer) is --procédure permetttant de détruire et déréférencer le slot 
      
      -- nous convertissons en quelque sort l'id en P_Slot afin de pouvoir en faire quelque chose
      Cible     : P_Slot := Trouver_Slot(id);


      Actuel    : P_Slot := emplacement_origin;
      Suivant   : P_Slot;
   begin

      -- en cas de faux id
      if Cible = null then
         return;
      end if;

      --nous rendons l'espace occupé par le slot
      disque_restant := disque_restant + Long_Integer(Cible.all.taille);

      -- si la cible est directement détectée nous la détruisons (afin de simuler au maximum nous utilisons Free qui libère littéralement l'espace occupé par une variable.)
      if Actuel.all.suivant = Cible then
         Actuel.all.suivant := Cible.all.suivant;
         Free(Cible);
         return;
      end if;

      --Nous parcourons toute la liste pour détecter la cible
      while Actuel.all.suivant /= null loop
         Suivant := Actuel.all.suivant;
         if Suivant = Cible then
            Actuel.all.suivant := Suivant.all.suivant;
            Free(Cible);
            return;
         end if;
         Actuel := Suivant;
      end loop;
   end Destruction;

   procedure Modif(id : in Integer; nouvelle_taille : in Integer) is  --procédure permetttant de modifier un slot
      Ancienne : Integer;
      Difference : Integer;
      Cible : P_Slot :=Trouver_Slot(id);
   begin
   --rien d'original
      if Cible = null then
         return;
      end if;
      Ancienne := Cible.all.taille;
      Difference := nouvelle_taille - Ancienne;
      if Difference > 0 then
         if not Check_Restant(Difference) then
            return;
         end if;
      end if;
      Cible.all.taille := nouvelle_taille;
      disque_restant := disque_restant - Long_Integer(Difference);
   end Modif;


   function Trouver_Slot(id : in integer) return P_Slot is --fonction permetttant de trouver un slot
      Actuel : P_Slot := emplacement_origin.all.suivant;
   begin
      --rien d'original
      while Actuel /= null loop
         if Actuel.all.address = id then
            return Actuel;
         end if;
         Actuel := Actuel.all.suivant;
      end loop;
      return null;
   end Trouver_Slot;


   function Check_Restant(taille : Integer) return Boolean is --fonction regardant si la taille restante est bonne 
   begin
      return disque_restant >= Long_Integer(taille);
   end Check_Restant;




end Disque;