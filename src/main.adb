with SGF;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   Fi : SGF.T_Fichier;
   nom_fichier : String := "Bonjour.txt";
begin
   SGF.Init_SGF;

   Put_Line(To_String(SGF.Racine.Nom));

   SGF.Touch(Fi => Fi, Nom => nom_fichier, Droits => 2#110#);

   Put_Line(To_String(SGF.Racine.Contenu.all.Fichier.all.Nom));
end Main;
