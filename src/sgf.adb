
with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;
package body SGF is   

procedure Init_SGF is --Initialise le dossier racine
begin
   Racine.Nom := To_Unbounded_String("/"); --U_String pour avoir des noms dynamiques
   Racine.Droits := 2#111#; -- read, write, exec
   Racine.Dossier_Parent := null; --La racine n'a par définition pas de parent
   Racine.Contenu := null; --Initialisation par défaut
   Actuel := Racine'Access; --Initialisation de la variable globale access
   disque_restant := disque_restant- 10; --On enlève la place prise par la racine (10 octets)
end Init_SGF;

procedure Ls is
   conten : P_Liste_Contenu;
begin
   begin
   conten := Actuel.all.Contenu;
   exception
      when Constraint_Error =>
         raise Uninitialized_SGF;
   end;
   Put ("Nom   ");
   Put ("Taille   ");
   Put_Line ("Droits");
   while conten /= null loop
      if conten.all.Est_Fichier = True then
         Put (To_String(conten.all.Fichier.all.Nom));
         Put (conten.all.Fichier.all.Taille);
         Put (conten.all.Fichier.all.Droits);
         New_Line;
      else
         Put (To_String(conten.all.Dossier.all.Nom));
         Put (conten.all.Dossier.all.Droits);
         New_Line;
      end if;
      conten := conten.all.Suivant;
   end loop;
end Ls;


procedure Pwd is
   procedure Afficher_Chemin (D : P_Dossier) is
   begin
      if D.all.Dossier_Parent = null then
         Put ("/");
         Put ("Dossier actuel : /");
      else
         Afficher_Chemin (D.all.Dossier_Parent);
         Put (To_String(D.all.Nom));
         Put ("/");
      end if;
   exception
   when Constraint_Error =>
   raise Uninitialized_SGF;
   end Afficher_Chemin;
begin
   Afficher_Chemin (Actuel);
   New_Line;
end Pwd;


   procedure Touch (Fi: out T_Fichier; Taille : in integer; Nom : in String; Droits : in Integer) is
      Li_cont : P_Liste_Contenu;
      N_Slot : T_Slot;
   begin
      if not Check_Restant (Taille) then
         raise No_Remaining_Place;
      end if;
      Creation (N_Slot, Taille);
      Fi.Nom := To_Unbounded_String(Nom);
      Fi.Taille := Taille;
      Fi.Droits := Droits;
      Fi.Id := N_Slot.address;

      Li_cont := new T_Liste_Contenu;
      Li_cont.Est_Fichier := True;
      Li_cont.Fichier := new T_Fichier'(Fi);
      Li_cont.Dossier := null;
      Li_cont.Suivant := null;
      begin
      if Actuel.all.Contenu = null then
         Actuel.all.Contenu := Li_cont;
      else
         declare
            C : P_Liste_Contenu := Actuel.all.Contenu;
         begin
            while C.all.Suivant /= null loop
               C := C.all.Suivant;
            end loop;
            C.all.Suivant := Li_cont;
         end;
      end if;

      exception
      when Constraint_Error =>
      raise Uninitialized_SGF;
      end;
   end Touch;


   procedure Touch (Dos : in out T_Dossier; Fi : out T_Fichier;
                    Nom : in String; Droits : in Integer) is
   begin
      null;
   end Touch;




procedure Mkdir (Chemin : in String; Nom : in String; Droits : in Integer; Parent : in P_Dossier) is
   Dossier_Acuel : P_Dossier := Actuel;
   Nouveau_Dossier : T_Dossier;
   P_Nouveau_Dossier : P_Dossier;
   P_Liste_Contenu_Nouveau : P_Liste_Contenu;
   Dernier : P_Liste_Contenu;
   Taille : integer :=10;
   N_Slot : T_Slot;
begin
   if not Check_Restant (Taille) then
      raise No_Remaining_Place;
   end if;
   Creation (N_Slot, Taille);
   Cd(Dossier_Acuel, Chemin);
   Nouveau_Dossier.Nom := To_Unbounded_String(Nom);
   Nouveau_Dossier.Droits := Droits;
   Nouveau_Dossier.Dossier_Parent := Dossier_Acuel;
   Nouveau_Dossier.Contenu := null;
   Nouveau_Dossier.Id := N_Slot.address;
   P_Nouveau_Dossier := new T_Dossier'(Nouveau_Dossier);
   P_Liste_Contenu_Nouveau := new T_Liste_Contenu'(
      Est_Fichier => False,
      Fichier     => null,
      Dossier     => P_Nouveau_Dossier,
      Suivant     => null
   );
   if Dossier_Acuel.all.Contenu = null then
      Dossier_Acuel.all.Contenu := P_Liste_Contenu_Nouveau;
   else
      Dernier := Dossier_Acuel.all.Contenu;
      while Dernier.all.Suivant /= null loop
         Dernier := Dernier.all.Suivant;
      end loop;
      Dernier.all.Suivant := P_Liste_Contenu_Nouveau;
   end if;

end Mkdir;



   procedure Cd (Cur : in out P_Dossier; Repertoire : in String) is
   Liste_Chemin : Liste_U_String := Split(Repertoire,'/');
   Elem : P_Liste_Contenu;
   begin
   for i in Liste_Chemin'Range loop
      declare
         Nom_Segment : constant String := To_String(Liste_Chemin(i));
      begin
         if Nom_Segment = " " then
            Cur := Racine'Access;

         elsif Nom_Segment = "." then
            null;

         elsif Nom_Segment = ".." then
            if Cur.all.Dossier_Parent /= null then
               Cur := Cur.all.Dossier_Parent;
            end if;

         else
            begin
            Elem := Cur.all.Contenu;
            exception
               when Constraint_Error =>
               raise Uninitialized_SGF;
            end;
            while Elem /= null loop
               if (not Elem.all.Est_Fichier)
                  and then (Elem.all.Dossier /= null)
                  and then (To_String(Elem.all.Dossier.all.Nom) = Nom_Segment)
               then
                  Cur := Elem.all.Dossier;
                  exit;
               end if;
               Elem := Elem.all.Suivant;
            end loop;
         end if;
      end;
   end loop;
end Cd;

procedure Modif_Taille(Chemin : in  String; Taille : Integer ; Fichier : out T_Fichier) is
begin
Fichier.Taille := Taille;
end Modif_Taille;

procedure Ls (Chemin : in String) is

   procedure Ls_chemin(Dos : in P_Liste_Contenu) is
   begin
      null;
   end Ls_chemin;

begin
   null;
end Ls;

function Recherche_chemin(Chemin : in String) return P_Liste_Contenu is

   procedure Chemin_Affichage(Chemin : in String) is
      liste_chemin : Liste_U_String := Split(Chemin, '/');
   begin
      Put ("Affichage du chemin : ");
      for i in liste_chemin'Range loop
         Put ("/");
         Put (i);
         Put (To_String(liste_chemin(i)));
      end loop;
      New_Line;
   end Chemin_Affichage;
   

   function Chemin_Existe(Chemin : in String) return Boolean is
      liste_chemin : Liste_U_String := Split(Chemin, '/');
      conten : P_Liste_Contenu := Racine.Contenu;
      ptr : P_Liste_Contenu;
   begin
      for i in liste_chemin'Range loop
         ptr := null;
         while conten /= null loop
            Put (To_String(conten.all.Dossier.all.Nom));
            if (not conten.all.Est_Fichier) 
            and then (To_String(conten.all.Dossier.all.Nom) = To_String(liste_chemin(i)))
            then
               ptr := conten;
            end if;
            conten := conten.all.Suivant;
         end loop;
         if ptr = null and i > 1 then
            return False;
         end if;
         if ptr = null and i = 1 then
            null;
         else
            conten := ptr.all.Dossier.all.Contenu;
         end if;
      end loop;
      return True;
   end Chemin_Existe;

   function Chemin_Ptr(Chemin : in String) return P_Liste_Contenu is
      liste_chemin : Liste_U_String := Split(Chemin, '/');
      conten : P_Liste_Contenu := Racine.Contenu;
      ptr : P_Liste_Contenu;
   begin
      for i in liste_chemin'Range loop
         ptr := null;
         while conten /= null loop
            if (not conten.all.Est_Fichier) 
            and then (To_String(conten.all.Dossier.all.Nom) = To_String(liste_chemin(i)))
            then
               ptr := conten;
            end if;
            conten := conten.all.Suivant;
         end loop;
         if ptr = null and i = 1 then
            null;
         else
            conten := ptr.all.Dossier.all.Contenu;
         end if;
      end loop;
      return ptr;
   end Chemin_Ptr;

begin

   Chemin_Affichage(Chemin);

   if Chemin_Existe(Chemin) then -- Verifie l'existence du chemin absolu renseigné
      return Chemin_Ptr(Chemin); -- Retourne le P_Liste_Contenu dudit chemin
   else
      return null;
   end if;
end Recherche_chemin;

procedure Lsr is
   conten2 : P_Liste_Contenu;
      Act : P_Liste_Contenu := Actuel.all.Contenu; -- Actuel de type P_Liste_Contenu
   procedure Ls_rec(Dos : in P_Liste_Contenu) is
      conten : P_Liste_Contenu;
   begin
      conten := Dos;
      while conten /= null loop
         if conten.all.Est_Fichier = True then
            Put (To_String(conten.all.Fichier.all.Nom));
            Put (conten.all.Fichier.all.Taille);
            Put (conten.all.Fichier.all.Droits);
            New_Line;
         else
            Put (To_String(conten.all.Dossier.all.Nom));
            Put (conten.all.Dossier.all.Droits);
            New_Line;
            Ls_rec (conten.all.Dossier.all.Contenu);
         end if;
         conten := conten.all.Suivant;
      end loop;
   end Ls_rec;

begin

   Put ("Nom   ");
   Put ("Taille   ");
   Put_Line ("Droits");
   conten2 := Actuel.all.Contenu;
   while conten2 /= null loop
      if conten2.all.Est_Fichier = True then
         Put (To_String(conten2.all.Fichier.all.Nom));
         Put (conten2.all.Fichier.all.Taille);
         Put (conten2.all.Fichier.all.Droits);
         New_Line;
      else
         Put (To_String(conten2.all.Dossier.all.Nom));
         Put (conten2.all.Dossier.all.Droits);
         New_Line;
         Ls_rec (conten2.all.Dossier.all.Contenu);
      end if;
      conten2 := conten2.all.Suivant;
   end loop;
   New_Line;
end Lsr;

procedure Lsr (Chemin : in String) is

   ptr_chemin : P_Liste_Contenu;

   procedure Ls_rec(Dos : in P_Liste_Contenu) is
      conten : P_Liste_Contenu;
   begin
      conten := Dos;
         Put ("Nom   ");
         Put ("Taille   ");
         Put_Line ("Droits");
      while conten /= null loop
         if conten.all.Est_Fichier = True then
            Put (To_String(conten.all.Fichier.all.Nom));
            Put (conten.all.Fichier.all.Taille);
            Put (conten.all.Fichier.all.Droits);
            New_Line;
         else
            Put (To_String(conten.all.Dossier.all.Nom));
            Put (conten.all.Dossier.all.Droits);
            New_Line;
            Ls_rec (conten.all.Dossier.all.Contenu);
         end if;
         conten := conten.all.Suivant;
      end loop;
   end Ls_rec;
   
begin

   -- 1. retrouver le P_Liste_Contenu à partir de la liste extraite
   ptr_chemin := Recherche_chemin(Chemin);
   if ptr_chemin = null then
      Put_Line ("Lsr(Chemin) : Chemin invalide");
   else
      -- 2. passer le P_Liste_Contenu en paramètre de Ls_rec
      Ls_rec(ptr_chemin);
   end if;

   New_Line;

end Lsr;

   procedure Rm (Chemin : String) is
      Liste    : Liste_U_String := Split(Chemin, '/');
      Courant  : P_Dossier := Actuel;
      Cible    : Unbounded_String;
      Precedent : P_Liste_Contenu;
      Parcours : P_Liste_Contenu;
      Id : Integer;
   begin
      if Courant = null then
         raise Uninitialized_SGF;
      end if;
      for I in 1 .. Liste'Length - 1 loop
         Courant := Trouver_Dos(To_String(Liste(I)), Courant);
         if Courant = null then
            Put_Line("Dossier inexistant");
            return;
         end if;
      end loop;

      Cible := Liste(Liste'Last);
      Precedent := null;
      Parcours  := Courant.Contenu;

      while Parcours /= null loop
         if Parcours.Est_Fichier and then To_String(Parcours.Fichier.Nom) = To_String(Cible) then
            Id := Parcours.Fichier.all.Id;
            Destruction (Id);
            if Precedent = null then
               Courant.Contenu := Parcours.Suivant;
            else
               Precedent.Suivant := Parcours.Suivant;
            end if;

            return;
         end if;

         Precedent := Parcours;
         Parcours  := Parcours.Suivant;
      end loop;


   end Rm;

   procedure Rmr (Dos : in out T_Dossier; Chemin : in String) is
   begin
      null;
   end Rmr;


   procedure Mv (Dos : in out T_Dossier; Fichier : in string; Dest : in String; Nom : in String) is
   Copie_Actuel : P_Dossier := Actuel;
   begin
      Cp(Dos,Fichier, Dest,Nom);
      Actuel := Copie_Actuel;
      Rm (Fichier);
   end Mv;    



   procedure Cp (Dos : in T_Dossier; Fichier : in String; Destination : in String ; Nouveau_nom : in string) is
   Copie_Fichier : T_Fichier := Trouver_Fi (Fichier, Actuel).all;
   Copie_Actuel : P_Dossier := Actuel;
   Fi : T_Fichier;
   begin
   if Nouveau_nom /= "rien" then
   Copie_Fichier.Nom := To_Unbounded_String(Nouveau_nom);
   end if;
   Cd(Actuel,Destination);
   Touch(Fi,Copie_Fichier.Taille,To_String(Copie_Fichier.Nom),Copie_Fichier.Droits);
   end Cp;

   function Split(chemin : String ; symbole : Character) return Liste_U_String is
         Compteur : Integer := 1;
         index    : Integer := 1;
         start    : Integer := 1;
         partie   : Unbounded_String := To_Unbounded_String("");
         Lst_U_vide : Liste_U_String(1..1);
      begin
         -- Count slashes to know the number of segments
         if chemin = "" then
         Lst_U_vide(1) := To_Unbounded_String("");
         return Lst_U_vide;
         end if;
         for i in chemin'Range loop
            if chemin(i) = symbole then
               Compteur := Compteur + 1;
            end if; 
         end loop;

         declare
            Result : Liste_U_String(1..Compteur);
         begin
            if chemin(1) = symbole then
               Result(index) := To_Unbounded_String(" ");
               index := index + 1;
               start := start + 1;
            end if;

            for i in start..chemin'Length loop
               if chemin(i) = symbole then
                  Result(index) := partie;
                  index := index + 1;
                  partie := To_Unbounded_String("");
               else
                  partie := partie & To_Unbounded_String(String'(1 => chemin(i)));
               end if;
            end loop;
            Result(index) := partie;
            return Result;
         end;
      end Split;

function Trouver_Fi(nom : string ; Dossier : P_Dossier) return P_Fichier is
   est_fichier : Boolean := True;
   Contenant : P_Dossier := Trouver_El_R(est_fichier, Dossier, nom, Actuel);
   Contenue_du_contenant : P_Liste_Contenu;
begin
   if Contenant = null then
      return null;
   end if;

   Contenue_du_contenant := Contenant.all.contenu;

   while Contenue_du_contenant /= null loop
      if Contenue_du_contenant.all.Est_Fichier
        and then To_String(Contenue_du_contenant.all.Fichier.all.Nom) = Nom then
   
         return Contenue_du_contenant.all.Fichier;
      end if;
      Contenue_du_contenant := Contenue_du_contenant.all.Suivant;
   end loop;

   return null;
end Trouver_Fi;

procedure Tar is
      Archive : T_Fichier;
      Taille_Totale : Integer;
      function Taille_Dossier (Dos : in P_Dossier) return Integer is
         Courant : P_Liste_Contenu := Dos.all.Contenu;
         Taille : Integer := 10;
      begin
         while Courant /= null loop
            if Courant.all.Est_Fichier then
               Taille := Taille + Courant.all.Fichier.all.Taille;
            else
               Taille := Taille + Taille_Dossier(Courant.all.Dossier);
            end if;
            Courant := Courant.all.Suivant;
         end loop;
         return Taille;
      end Taille_Dossier;
      Nom_Archive : constant String := To_String(Actuel.all.Nom) & ".tar";
   begin
      if Actuel = null then
         raise Uninitialized_SGF;
      end if;
      Taille_Totale := Taille_Dossier(Actuel);
      Touch(Archive, Taille_Totale, Nom_Archive, 2#110#);  -- droits rw-
   end Tar;


function Trouver_Dos(nom : string ; Dossier : P_Dossier) return P_Dossier is
   est_fichier : Boolean := False;
   Contenant : P_Dossier := Trouver_El_R(est_fichier, Dossier, nom, Actuel);
   Contenue_du_contenant : P_Liste_Contenu;
begin
   if Contenant = null then
      return null;
   end if;

   Contenue_du_contenant := Contenant.all.contenu;
   while Contenue_du_contenant /= null loop
      if (not Contenue_du_contenant.all.Est_Fichier)
        and then To_String(Contenue_du_contenant.all.Dossier.all.Nom) = Nom then
         return Contenue_du_contenant.all.Dossier;
      end if;
      Contenue_du_contenant := Contenue_du_contenant.all.Suivant;
   end loop;

   return null;
end Trouver_Dos;


function Trouver_El_R (Fichier : Boolean; Dossier : P_Dossier;Nom     : String; Precedent : P_Dossier) return P_Dossier is
Actuel : P_Liste_Contenu := Dossier.all.Contenu;
begin
   Put(Boolean'Image(Fichier));  
   while Actuel /= null loop
      if Actuel.all.Est_Fichier then
         if Fichier then

            if To_String (Actuel.all.Fichier.all.Nom) = Nom then
               Put_Line("Fichier Identifié");
               return Dossier;
            end if;
         end if;

      else 
         if not Fichier then
            Put_Line("Dossier identifié");
            if To_String (Actuel.all.Dossier.all.Nom) = Nom then
               return Dossier;
            end if;
         end if;
         declare
            Result : P_Dossier := Trouver_El_R (Fichier,Actuel.all.Dossier,Nom,Dossier);
         begin
            if Result /= null then
               return Result;
            end if;
         end;
      end if;

      Actuel := Actuel.all.Suivant;
   end loop;

   return null;
end Trouver_El_R;
end SGF;