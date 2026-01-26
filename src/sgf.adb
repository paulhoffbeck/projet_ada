
with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;
package body SGF is   

procedure Init_SGF is
begin
   Racine.Nom := To_Unbounded_String("/");
   Racine.Droits := 2#111#; -- read, write, exec
   Racine.Dossier_Parent := null;
   Racine.Contenu := null;
   --PEUT ETRE VERIFIER QUE LE DISQUE EST TOTALEMENT REMPLIS
   Actuel := Racine'Access;

   disque_restant := disque_restant- 10;
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
         Put_Line (conten.all.Fichier.all.Droits);
      else
         Put (To_String(conten.all.Dossier.all.Nom));
         Put_Line (conten.all.Dossier.all.Droits);
      end if;
      conten := conten.all.Suivant;
   end loop;
end Ls;


procedure Pwd is
   procedure Afficher_Chemin (D : P_Dossier) is
   begin
      if D.all.Dossier_Parent = null then
         Put ("/");
         Put_Line ("Dossier actuel : /");
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
end Pwd;


   procedure Touch (Fi: out T_Fichier; Taille : in integer; Nom : in String; Droits : in Integer) is
      Li_cont : P_Liste_Contenu;
      N_Slot : T_Slot;
   begin
      if not Check_Restant (Taille) then
         raise No_Remaining_Place;
      end if;

      Fi.Nom := To_Unbounded_String(Nom);
      Fi.Taille := Taille;
      Fi.Droits := Droits;

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
      Creation (N_Slot, Taille);
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


function Trouver_fichier (Chemin : String) return T_Fichier is
Fi : T_Fichier;
begin
null;
return Fi;

end Trouver_fichier;


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
   Cd(Dossier_Acuel, Chemin);
   Nouveau_Dossier.Nom := To_Unbounded_String(Nom);
   Nouveau_Dossier.Droits := Droits;
   Nouveau_Dossier.Dossier_Parent := Dossier_Acuel;
   Nouveau_Dossier.Contenu := null;
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
   Creation (N_Slot, Taille);
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

procedure Lsr is
begin
   conten := Actuel; -- Actuel de type P_Liste_Contenu
   while conten /= null loop
      if conten.all.Est_Fichier = True then
         Put (To_String(conten.all.Fichier.all.Nom));
         Put (conten.all.Fichier.all.Taille);
         Put (conten.all.Fichier.all.Droits);
      else
         Put (To_String(conten.all.Dossier.all.Nom));
         Put (conten.all.Dossier.all.Droits);
         Ls_rec (conten.all.Dossier.all.Contenu);
      end if;
      conten := conten.all.Suivant;
   end loop;
end Lsr;

procedure Lsr (Chemin : in String) is

   liste_chemin : Liste_U_String;
   temp_chemin : P_Liste_Contenu;
   conten : P_Liste_Contenu;
   i : Integer;

   procedure Ls_rec(Dos : in P_Liste_Contenu) is
   begin
      conten := Dos;
      while conten /= null loop
         if conten.all.Est_Fichier = True then
            Put (To_String(conten.all.Fichier.all.Nom));
            Put (conten.all.Fichier.all.Taille);
            Put (conten.all.Fichier.all.Droits);
         else
            Put (To_String(conten.all.Dossier.all.Nom));
            Put (conten.all.Dossier.all.Droits);
            Ls_rec (conten.all.Dossier.all.Contenu);
         end if;
         conten := conten.all.Suivant;
      end loop;
   end Ls_rec;
   
begin
   -- 1. split le chemin donné en entrée
   liste_chemin := Split(Chemin);

   -- 2. retrouver le P_Liste_Contenu à partir de la liste extraite
  temp_chemin := Recherche_chemin(Chemin);

   -- 3. passer le P_Liste_Contenu en paramètre de Ls_rec
   Ls_rec(temp_chemin);

end Lsr;

procedure Recherche_chemin(Chemin : in String) return P_Dossier is
begin
   liste_chemin := Split(Chemin);
   conten := Racine.Contenu;
   while conten /= null loop
      if conten.all.Est_Fichier = True then
         Put ("Le dossier renseigné est un fichier");
      else if (not conten.all.Est_Fichier)
               and then (conten.all.Dossier /= null)
               and then (To_String(conten.all.Dossier.all.Nom) = liste_chemin'Last) then
         Elem := conten;
         while Elem /= null loop
            if (not Elem.all.Est_Fichier)
               and then (Elem.all.Dossier /= null)
               and then (To_String(Elem.all.Dossier.all.Nom) = Nom_Segment)
            then
               Cur := Elem.all.Dossier;
               exit;
            end if;
            Elem := Elem.all.Suivant;     
      end if;
      conten := conten.all.Suivant;
   end loop;
end Recherche_chemin;


   procedure Rm (Dos : in out T_Dossier; Index : in Indexeur) is
   begin
      null;
   end Rm;


   procedure Rmr (Dos : in out T_Dossier; Chemin : in String) is
   begin
      null;
   end Rmr;


   procedure Mv (Dos : in out T_Dossier; Dest : in String; Nom : in String) is
   begin
      null;
   end Mv;


   procedure Cpr (Dos : in T_Dossier; Element : in String; Destination : in String) is
   begin
      null;
   end Cpr;

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
