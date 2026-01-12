with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body sgf is 

procedure Init_SGF is
begin
   Racine.Nom := To_Unbounded_String("/");
   Racine.Droits := 2#111#; -- read, write, exec
   Racine.Dossier_Parent := null;
   Racine.Contenu := null;

   Actuel := Racine'Access;
end Init_SGF;

procedure Ls is
conten : P_Dossier;
begin
   conten := actuel.all.contenu;
   while conten /= null loop
      if conten.all.Est_Fichier = True then
         Put (conten.all.Fichier.all.Nom);
         Put (conten.all.Fichier.all.Taille);
         Put (conten.all.Fichier.all.Droits);
      else
         Put (conten.all.Dossier.all.Nom);
         Put (conten.all.Dossier.all.Droits);
      end if;
      conten := conten.all.Suivant;
   end loop;
end Ls;

procedure Pwd is

   Actuel : P_Dossier;

   procedure Afficher_Chemin (D : P_Dossier) is
   begin
      if D.all.Dossier_Parent = null then
         -- Racine
         Put ("/");
      else
         Afficher_Chemin (D.all.Dossier_Parent);
         Put (D.all.Nom);
         Put ("/");
      end if;
   end Afficher_Chemin;

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





end sgf;