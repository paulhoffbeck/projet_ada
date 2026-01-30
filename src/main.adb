with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;

procedure Main is
choix : Integer;
begin

      --détecte les choix de l'utilisateur et démare les bonnes procédures selon les choix
   while True loop
      Afficher_Banniere_Main;
      begin
      Get(choix);
               exception
         when Data_error =>
         Put_Line("Veillez entrer un nombre !!");
         Skip_Line;
      end;
      begin
      case choix is 
         when 1 =>
            Menu;
            exit;
         when 2 =>
            Cmd;
            exit;
         when 3 =>
            exit;
         when others =>
         Put_Line("Choix de nombre invalide !");
      end case;
      exception 
         when Data_error =>
            Put_Line("Nombre d'arguments invalides !");
            Skip_Line;
      end;
   end loop;
end Main;
