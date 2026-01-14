with SGF;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   Fi : SGF.T_Fichier;
   nom_fichier : String := "Bonjour.txt";
   Liste : SGF.Liste_U_String := SGF.Split("../local/bin");
begin
   SGF.Init_SGF;

   Put_Line(To_String(SGF.Racine.Nom));

   SGF.Touch(Fi => Fi, Nom => nom_fichier, Droits => 2#110#);

   Put_Line(To_String(SGF.Racine.Contenu.all.Fichier.all.Nom));

   for I in Liste'Range loop
      Put_Line("Segment " & I'Image & " = " & To_String(Liste(I)));
   end loop;


end Main;
