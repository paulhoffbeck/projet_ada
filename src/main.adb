with SGF;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is
   Dossier : SGF.T_Dossier;
begin
   SGF.Init_SGF (Dossier);
   Put_Line(To_String(Dossier.Nom));
end Main;