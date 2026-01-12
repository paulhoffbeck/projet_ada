with Ada.Text_IO; use Ada.Text_IO;
package body SGF is 

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
      if D = null then
         -- Racine
         Put ("/");
      else
         Afficher_Chemin (D.all.Parent);
         Put (D.all.Nom);
         Put ("/");
      end if;
   end Afficher_Chemin;

begin
   Afficher_Chemin (Actuel);
   New_Line;
end Pwd;



end SGF;