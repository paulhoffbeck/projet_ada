with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Main is
choix : Integer;

   procedure Afficher_Banniere_Main is
   begin
      Put_Line ("+-----------------------------------------------+");
      Put_Line ("|           Bienvenue dans le SGF               |");
      Put_Line ("|-----------------------------------------------|");
      Put_Line ("|   1. Mode Menu (navigation par chiffres)      |");
      Put_Line ("|   2. Mode Terminal (commandes manuelles)      |");
      Put_Line ("|   3. Quitter                                  |");
      Put_Line ("|                                               |");
      Put_Line ("|   Entrez votre choix (1-3)                    |");
      Put_Line ("+-----------------------------------------------+");
   end Afficher_Banniere_Main;

   procedure Afficher_Banniere_Menu is
   begin
      Put_Line ("+-----------------------------------------------+");
      Put_Line ("|      Bienvenue dans le SGF mode menu          |");
      Put_Line ("|-----------------------------------------------|");
      Put_Line ("|   1. Créer un SGF                             |");
      Put_Line ("|   2. Créer un dossier                         |");
      Put_Line ("|   3. Créer un fichier                         |");
      Put_Line ("|   4. Changer de répertoire                    |");
      Put_Line ("|   5. Afficher le répertoire                   |");
      Put_Line ("|   6. Changer de répertoire                    |");
      Put_Line ("|   7. Revenir au chois de mode                 |");
      Put_Line ("|                                               |");
      Put_Line ("|   Entrez votre choix (1-7)                    |");
      Put_Line ("+-----------------------------------------------+");
   end Afficher_Banniere_Menu;

   procedure Menu is
   begin
      choix :=0;
      Afficher_Banniere_Menu;
      Get(choix);
      case choix is
         when 1 =>
            Put_Line("Init");
         when 2 =>
            Put_Line("Mkdir");
         when 3 =>
            Put_Line("Touch");
          
         when 4 =>
            Put_Line("cd");
         when 5 =>
            Put_Line("ls");
         when 6 =>
            Put_Line("Changement de répertoire choisi");
         when 7 =>
            Main;
         when others =>
            Put_Line ("Choix invalide");
   end case;
   end Menu;



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
