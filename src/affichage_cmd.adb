
with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;
package body Affichage_cmd is


procedure Afficher_Aide is
begin
   Put_Line("+-------------------------------------------------------------+");
   Put_Line("|                       AIDE DU SGF                           |");
   Put_Line("|-------------------------------------------------------------|");
   Put_Line("| Commandes disponibles :                                     |");
   Put_Line("|                                                             |");
   Put_Line("| init                            : Initialise le SGF         |");
   Put_Line("| mkdir <chemin> <nom> <droits>  : Crée un dossier            |");
   Put_Line("| touch <nom> <droits> <taille>  : Crée un fichier            |");
   Put_Line("| cd <repertoire>                 : Change le répertoire      |");
   Put_Line("| ls                              : Liste le contenu          |");
   Put_Line("| ls <chemin>                     : Liste un chemin précis    |");
   Put_Line("| lsr                             : Liste récursive contenu   |");
   Put_Line("| lsr <chemin>                    : Liste récursive chemin    |");
   Put_Line("| pwd                             : Affiche le chemin actuel  |");
   Put_Line("| find <nom>                      : Recherche un fichier      |");
   Put_Line("| cp <src> <dst> <nouveau_nom>   : Copie fichier/dossier      |");
   Put_Line("| mv <src> <dst> <nouveau_nom>   : Déplace/renomme fichier    |");
   Put_Line("| rm <nom>                        : Supprime fichier/dossier  |");
   Put_Line("| tar                             : Archive répertoire courant|");
   Put_Line("| help                            : Affiche cette aide        |");
   Put_Line("| menu                            : Passer au mode menu       |");
   Put_Line("| exit                            : Fermer le terminal        |");
   Put_Line("|                                                             |");
   Put_Line("|                                                             |");
   Put_Line("| ! Important ! : Veuillez initialiser le SGF avant tout      |");
   Put_Line("|                                                             |");
   Put_Line("+-------------------------------------------------------------+");

end Afficher_Aide;


   procedure Cmd is --Procédure gérant le cmd.
      Commande  : String (1..200);
      LongCommande : Natural;
   begin
      Skip_Line;
      while True loop
         Put(">");
         Get_Line(Commande,LongCommande);
         Trouver_Commande(Commande(1..LongCommande));

      end loop;
      exception 
         when Sortie =>
         return;
   end Cmd;

   procedure Trouver_Commande(Commandes : in String) is --Procédure redirigeant des paramètres entrés en commande vers les bonnes méthodes
      Liste_param : Liste_U_String := Split(Commandes, ' '); -- la commande est d'abord découpée avant d'être analysée bout à bout
      Taille : integer := Liste_param'Length;
      Commande : String := To_String(Liste_param(1));
      Nb_El : Integer := Liste_param'Length;
   begin
      if Commande = "init" or Commande = "INIT" or Commande = "Init" then
         Init_SGF;
      else if Commande = "mkdir" or Commande = "MKDIR" or Commande = "Mkdir" then
         Cmd_Faire_Mkdir(Liste_param, Nb_El);

      else if Commande = "touch" or Commande = "TOUCH" or Commande = "Touch" then
         Cmd_Faire_Touch(Liste_param, Nb_El);

      else if Commande = "cd" or Commande = "CD" or Commande = "Cd" then
         Cmd_Faire_Cd(Liste_param, Nb_El);

      else if Commande = "ls" or Commande = "LS" or Commande = "Ls" then
         Cmd_Faire_Ls(Liste_param, Nb_El);

      else if Commande = "pwd" or Commande = "PWD" or Commande = "Pwd" then
         Cmd_Faire_Pwd(Liste_param, Nb_El);

      else if Commande = "find" or Commande = "FIND" or Commande = "Find" then
         Cmd_Faire_Find(Liste_param, Nb_El);

      else if Commande = "cp" or Commande = "CP" or Commande = "Cp" then
         Cmd_Faire_Cp (Liste_param, Nb_El);
      else if Commande = "mv" or Commande = "MV" or Commande = "Mv" then
         Cmd_Faire_Mv (Liste_param, Nb_El);

      else if Commande = "tar" or Commande = "TAR" or Commande = "Tar" then
         Tar;

      else if Commande = "rm" or Commande = "RM" or Commande = "Rm" then
         Cmd_Faire_Rm(Liste_param, Nb_El);

      else if Commande = "help" or Commande = "HELP" or Commande = "Help" then
         Afficher_Aide;
      
      else if Commande = "exit" or Commande = "EXIT" or Commande = "Exit" then
         raise Sortie;
      
      else if Commande = "menu" or Commande = "MENU" or Commande = "Menu" then
         Menu;

      else if Commande = "cowsay" or Commande = "COWSAY" or Commande = "Cowsay" then
         Faire_Fonctionimportante(Liste_param, Nb_El);

      else if Commande ="" then
         null;
      

      else
         Put_Line("Commande inconnue");
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      end if;
      exception 
         when Constraint_Error =>
            Put_Line("Mauvais arguments !");

         when Uninitialized_SGF =>
            Put_Line("SGF non initialisé :( ");

         when Incorect_Argument_Number => 
            Put_Line("Nombre d'argument incorecte !");

         when No_Remaining_Place =>
            Put_Line("Plus de place disponible, veuillez supprimer un fichier ou créer un fichier plus petit");
   end Trouver_Commande;

   procedure Cmd_Faire_Mkdir(Liste_param : Liste_U_String ; Nb_El : Integer) is --procédure permettant l'exécution de mkdir avec les paramètres mis en entrée
      Str : string := To_String(Liste_param(2));
      Str2 : string := To_String(Liste_param(3));
      Str3 : string := To_String(Liste_param(4));
      Int : Integer := Integer'Value(Str3);
   begin
      case Nb_El is
         when 4 =>
            Mkdir(Str, Str2, Int, Actuel);
         when others =>
            raise Incorect_Argument_Number;
      end case;
   end Cmd_Faire_Mkdir;

   procedure Cmd_Faire_Touch(Liste_param : Liste_U_String ; Nb_El : Integer) is --procédure permettant l'exécution de touch avec les paramètres mis en entrée
      Fi : T_Fichier;
      Str : string := To_String(Liste_param(2));
      Str2 : string := To_String(Liste_param(3));
      Str3 : string := To_String(Liste_param(4));
      Int : Integer := Integer'Value(Str2);
      Int2 : Integer := Integer'Value(Str3);
   begin

      case Nb_El is
         when 4 =>
            Touch(Fi,Int2,Str,Int);
         when others =>
            raise Incorect_Argument_Number;
      end case;
   end Cmd_Faire_Touch;

   procedure Cmd_Faire_Cd(Liste_param : Liste_U_String ; Nb_El : Integer) is   --procédure permettant l'exécution de Cd avec les paramètres mis en entrée
      Str : string := To_String(Liste_param(2));
   begin
      Cd(Actuel,Str);
   end Cmd_Faire_Cd;

   procedure Cmd_Faire_Ls(Liste_param : Liste_U_String ; Nb_El : Integer) is --procédure permettant l'exécution de ls avec les paramètres mis en entrée
   begin
      case Nb_El is
         when 1 =>
            Ls;
            New_Line;
         when others =>
            raise Incorect_Argument_Number;
      end case;
   end Cmd_Faire_Ls;

   procedure Cmd_Faire_Pwd(Liste_param : Liste_U_String ; Nb_El : Integer) is    --procédure permettant l'exécution de pwd avec les paramètres mis en entrée
      begin
         case Nb_El is
            when 1 =>
               Pwd;
               New_Line;
            when others =>
               raise Incorect_Argument_Number;
         end case;
      end Cmd_Faire_Pwd;

   procedure Cmd_Faire_Find(Liste_param : Liste_U_String ; Nb_El : Integer) is    --procédure permettant l'exécution de find avec les paramètres mis en entrée
      Str : String := To_String(Liste_param(2));
      Choix : Boolean := Choix_Fi(Str);
      Fichier : P_Fichier := null;
      Dossier : P_Dossier := null;
   begin
      Case Nb_El is
         when 2 =>
            if Choix then
               Fichier := Trouver_Fi(Str,Actuel);
               if Fichier /= null then
                  Put_Line("Nom    : " & To_String(Fichier.all.Nom));
                  Put_Line("Taille : " & Integer'Image(Fichier.all.Taille));
                  Put_Line("Droits : " & Integer'Image(Fichier.all.Droits));
               else
                  Put_Line("Fichier non trouvé.");
               end if;
            else
               Dossier := Trouver_Dos(Str,Actuel);
               if Dossier /= null then
                  Put_Line("Nom    : " & To_String(Dossier.all.Nom));
                  Put_Line("Droits : " & Integer'Image(Dossier.all.Droits));
                  if Dossier.all.Dossier_Parent /= null then
                     Put_Line("Parent : " & To_String(Dossier.all.Dossier_Parent.all.Nom));
                  else
                     Put_Line("Parent : (racine)");
                  end if;
               else
                  Put_Line("Dossier non trouvé.");
               end if;
            end if;
         when others =>
            raise Incorect_Argument_Number;
   end case;
   end Cmd_Faire_Find;

   procedure Cmd_Faire_Mv(Liste_param : Liste_U_String ; Nb_El : Integer) is     --procédure permettant l'exécution de mv avec les paramètres mis en entrée
      Src : string := To_String(Liste_param(2));
      Dst : string := To_String(Liste_param(3));
      Nn : string := To_String(Liste_param(4));
   begin
      Case Nb_El is
         when 4 =>
            Mv(Actuel.all,Src,Dst,Nn);
         when others =>
            raise Incorect_Argument_Number;
      end case;
   end Cmd_Faire_Mv;

   procedure Cmd_Faire_Cp(Liste_param : Liste_U_String ; Nb_El : Integer) is    --procédure permettant l'exécution de cp avec les paramètres mis en entrée
      Src : string := To_String(Liste_param(2));
      Dst : string := To_String(Liste_param(3));
      Nn : string := To_String(Liste_param(4));
   begin
      Case Nb_El is
         when 4 =>
            Cp(Actuel.all,Src,Dst,Nn);
         when others =>
            raise Incorect_Argument_Number;
      end case;
   end Cmd_Faire_Cp;

   procedure Cmd_Faire_Rm(Liste_param : Liste_U_String ; Nb_El : Integer)is    --procédure permettant l'exécution de rm avec les paramètres mis en entrée
      Target : string := To_String(Liste_param(2));
   begin
      Case Nb_El is
         when 2 =>
            Rm(Target);
         when others =>
            raise Incorect_Argument_Number;
         end case;
   end Cmd_Faire_Rm;












































   procedure Fonction_importante(Message : in String) is
   Max_Len : constant Integer := 40;
   Line     : String(1..Max_Len);
   Msg_Len  : Integer;
   Start    : Integer := 1;
   End_Pos  : Integer;
   begin
   loop
      if Start > Message'Length then
         exit;
      end if;
      End_Pos := Start + Max_Len - 1;
      if End_Pos > Message'Length then
         End_Pos := Message'Length;
      end if;

      Msg_Len := End_Pos - Start + 1;
      Line(1..Msg_Len) := Message(Start..End_Pos);
      if Start = 1 then
         Put ("  ");
         for I in 1..Msg_Len loop
            Put ("-");
         end loop;
         New_Line;
      end if;

      Put ("< ");
      Put (Line(1..Msg_Len));
      Put_Line (" >");

      if End_Pos = Message'Length then
         Put ("  ");
         for I in 1..Msg_Len loop
            Put ("-");
         end loop;
         New_Line;
      end if;

      Start := End_Pos + 1;
   end loop;
   Put_Line("        \   ^__^");
   Put_Line("         \  (oo)\_______");
   Put_Line("            (__)\       )\/\");
   Put_Line("                ||----w |");
   Put_Line("                ||     ||");
end Fonction_importante;

procedure Faire_Fonctionimportante(Liste_param : Liste_U_String ; Nb_El : Integer) is
      Src : string := To_String(Liste_param(2));
   begin

   Fonction_importante(Src);
end Faire_Fonctionimportante;

end Affichage_cmd;