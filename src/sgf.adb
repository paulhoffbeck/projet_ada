with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body sgf is 

procedure Init_SGF (Dos : out T_Dossier) is
begin
   Dos.Nom := To_Unbounded_String("/");
   Dos.Droits := 2#111#; -- read, write, exec
   Dos.Dossier_Parent := null;
   Dos.Contenu := null;
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

begin
   Afficher_Chemin (Actuel);
   New_Line;
end Pwd;

end sgf;