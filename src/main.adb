with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;

procedure Main is
choix : Integer;

begin
   while True loop
      Afficher_Banniere_Main;
      Get(choix);
      case choix is 
         when 1 =>
            Menu;
            exit;
         when 2 =>
            Put_Line("Cmd");
            exit;
         when 3 =>
            exit;
         when others =>
            Put_Line ("Choix invalide");
      end case;
   end loop;
end Main;
