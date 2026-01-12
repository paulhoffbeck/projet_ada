with Ada.Text_IO; use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package body SGF is 

procedure Init_SGF (Dos : out T_Dossier) is
begin
   Dos.Nom := To_Unbounded_String("/");
   Dos.Droits := 2#111#; -- read, write, exec
   Dos.Dossier_Parent := null;
   Dos.Contenu := null;
end Init_SGF;


end SGF;