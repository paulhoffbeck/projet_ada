with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   Fi : SGF.T_Fichier;
   nom_fichier : constant String := "Bonjour.txt";

   -- Petite procédure locale pour afficher l’arborescence
   procedure Affiche_Arbre (Dos : SGF.P_Dossier; Indent : Integer := 0) is
      Elem : SGF.P_Liste_Contenu;
   begin
      for I in 1 .. Indent loop
         Put("  ");
      end loop;
      Put_Line(To_String(Dos.all.Nom) & "/");

      Elem := Dos.all.Contenu;
      while Elem /= null loop
         if Elem.all.Est_Fichier then
            for I in 1 .. Indent + 1 loop
               Put("  ");
            end loop;
            Put_Line("- " & To_String(Elem.all.Fichier.all.Nom));
         else
            Affiche_Arbre(Elem.all.Dossier, Indent + 1);
         end if;
         Elem := Elem.all.Suivant;
      end loop;
   end Affiche_Arbre;

begin
   -- Initialisation
   SGF.Init_SGF;
   Put_Line("Répertoire courant après Init : " & To_String(SGF.Racine.Nom));

   -- Création d’un fichier à la racine
   SGF.Touch(Fi => Fi, Nom => nom_fichier, Droits => 2#110#);
   Put_Line(To_String(SGF.Racine.Contenu.all.Fichier.all.Nom));

   for I in Liste'Range loop
      Put_Line("Segment " & I'Image & " = " & To_String(Liste(I)));
   end loop;


   SGF.Pwd;
   SGF.Ls;
end Main;
