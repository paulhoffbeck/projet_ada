with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO; -- Permet d'afficher des entiers via Put()
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded; -- Permet d'utiliser des chaînes de char variables

package body SGF is 

procedure Init_SGF is
begin
   Racine.Nom := To_Unbounded_String("/");
   Racine.Droits := 2#111#; -- read, write, exec
   Racine.Dossier_Parent := null;
   Racine.Contenu := null;

   Actuel := Racine'Access;
end Init_SGF;

procedure Ls is
   conten : P_Liste_Contenu;
begin
   conten := Actuel.all.Contenu;
   Put ("Nom   ");
   Put ("Taille   ");
   Put_Line ("Droits");
   while conten /= null loop
      if conten.all.Est_Fichier = True then
         Put (To_String(conten.all.Fichier.all.Nom));
         Put (conten.all.Fichier.all.Taille);
         Put (conten.all.Fichier.all.Droits);
      else
         Put (To_String(conten.all.Dossier.all.Nom));
         Put (conten.all.Dossier.all.Droits);
      end if;
      conten := conten.all.Suivant;
   end loop;
end Ls;


   procedure Pwd is
   begin
      null;
   end Pwd;


   procedure Touch (Fi: out T_Fichier; Nom : in String; Droits : in Integer) is
      Li_cont : P_Liste_Contenu;
   begin
      Fi.Nom := To_Unbounded_String(Nom);
      Fi.Taille := 0;
      Fi.Droits := Droits;

      Li_cont := new T_Liste_Contenu;
      Li_cont.Est_Fichier := True;
      Li_cont.Fichier := new T_Fichier'(Fi);
      Li_cont.Dossier := null;
      Li_cont.Suivant := null;

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
   end Touch;


   procedure Touch (Dos : in out T_Dossier; Fi : out T_Fichier;
                    Nom : in String; Droits : in Integer) is
   begin
      null;
   end Touch;


   procedure Modif_Taille (Dos : in T_Dossier; Fichier : in out T_Fichier;
                           Taille : in Integer) is
   begin
      null;
   end Modif_Taille;


   procedure Mkdir (Dos : in out T_Dossier; Rep : out T_Dossier;
                    Nom : in String; Droits : in Integer;
                    Parent : in P_Dossier) is
   begin
      null;
   end Mkdir;


   procedure Cd (Dos : in out T_Dossier; Repertoire : in String) is
   begin
      null;
   end Cd;


   procedure Ls (Chemin : in String) is
   begin
      null;
   end Ls;


procedure Lsr (Chemin : in String) is
begin
   Conten := Actuel.all.Contenu;
   while Conten /= null loop
      if Conten.all.Est_Fichier = True then
         Put (To_String(conten.all.Fichier.all.Nom));
         Put (conten.all.Fichier.all.Taille);
         Put (conten.all.Fichier.all.Droits);
      else
         Put (To_String(conten.all.Dossier.all.Nom));
         Put (conten.all.Dossier.all.Droits);
         Lsr (Conten.all.Dossier.all.Contenu.all);
      end if;
      Conten := Conten.all.Suivant;
   end loop;
end Lsr;


   procedure Lsr (Dos : in T_Dossier) is
   begin
      null;
   end Lsr;


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

   function Split(chemin : String) return Liste_U_String is
         Compteur : Integer := 1;
         index    : Integer := 1;
         start    : Integer := 1;
         partie   : Unbounded_String := To_Unbounded_String("");
      begin
         -- Count slashes to know the number of segments
         for i in chemin'Range loop
            if chemin(i) = '/' then
               Compteur := Compteur + 1;
            end if; 
         end loop;

         declare
            Result : Liste_U_String(1..Compteur);
         begin
            if chemin(1) = '/' then
               Result(index) := To_Unbounded_String(" ");
               index := index + 1;
               start := start + 1;
            end if;

            for i in start..chemin'Length loop
               if chemin(i) = '/' then
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




end SGF;
