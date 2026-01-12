with Ada.Text_IO; use Ada.Text_IO;
package body SGF is 
procedure Init_SGF (Dos : out T_Dossier) is
begin
   Dos.Nom := "/";
   Dos.Droits := 2#111#; -- read, write, exec
   Dos.Dossier_Parent := null;
   Dos.Contenu := null;
end Init_SGF;
end SGF;