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