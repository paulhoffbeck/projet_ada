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

   procedure Creation(slot : out T_Slot ; taille : in Integer) is
   place : Boolean := Check_Restant (taille);
   begin
      if place then
         slot.address := compteur;
         slot.taille := taille;
         Ajouter_Slot (slot);
         disque_restant := disque_restant - Long_Integer(taille);
         compteur := compteur + 1;
      else
         Put_Line("Espace insuffisant !");
      end if;
   end Creation;

   procedure Ajouter_Slot(slot : in T_Slot) is
   Actuel : P_Slot := emplacement_origin;
   begin
      while Actuel.all.suivant /= null loop
         Actuel := Actuel.all.suivant;
      end loop;
      Actuel.all.suivant := new T_Slot'(slot);
   end Ajouter_Slot;

   procedure Destruction(id : in Integer) is
      Cible     : P_Slot := Trouver_Slot(id);
      Actuel    : P_Slot := emplacement_origin;
      Suivant   : P_Slot;
   begin
      if Cible = null then
         return;
      end if;

      disque_restant := disque_restant + Long_Integer(Cible.all.taille);
      if Actuel.all.suivant = Cible then
         Actuel.all.suivant := Cible.all.suivant;
         Free(Cible);
         return;
      end if;
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

   procedure Modif(id : in Integer; nouvelle_taille : in Integer) is
      Cible : P_Slot := Trouver_Slot(id);
      Ancienne : Integer;
      Difference : Integer;
   begin
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


   function Trouver_Slot(id : in integer) return P_Slot is
      Actuel : P_Slot := emplacement_origin.all.suivant;
   begin
      while Actuel /= null loop
         if Actuel.all.address = id then
            return Actuel;
         end if;
         Actuel := Actuel.all.suivant;
      end loop;
      return null;
   end Trouver_Slot;


   function Check_Restant(taille : Integer) return Boolean is
   begin
      return disque_restant >= Long_Integer(taille);
   end Check_Restant;




end Disque;