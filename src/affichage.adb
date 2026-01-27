with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;

package body Affichage is
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

   procedure Faire_Init is
   begin
      Init_SGF;
   end Faire_Init;

   procedure Faire_Dossier is
   Nom     : String (1..100);
   Chemin  : String (1..200);
   LongNom : Natural;
   LongChemin : Natural;
   Droits  : Integer;
   begin
      Skip_Line;
      Put ("Nom du dossier : ");
      Get_Line(Nom, LongNom);
      New_Line;
      Put ("Chemin du dossier : ");
      Get_Line(Chemin, LongChemin);
      Put_Line("Quelles droits voulez vous (111 = rwe, 000 = rien, 010 = rien, write, rien )");
      Get(droits);
      Mkdir(Chemin(1..LongChemin), Nom(1..LongNom), Droits, Actuel);
   end Faire_Dossier;

   procedure Faire_Touch is
   Nom     : String (1..100);
   Chemin  : String (1..200);
   LongNom : Natural;
   LongChemin : Natural;
   Droits  : Integer;
   Taille : Integer;
   Fi : T_Fichier;
   begin
      Skip_Line;
      Put ("Nom du Fichier : ");
      Get_Line(Nom, LongNom);
      New_Line;
      Put ("Chemin du Fichier : ");
      Get_Line(Chemin, LongChemin);
      Put_Line("Quelles droits voulez vous (111 = rwe, 000 = rien, 010 = rien, write, rien )");
      Get(droits);
      Put_Line("Quelle est la taille de votre fichier (en nombre d'octet)?");
      Get(Taille);
      Touch(Fi, Taille, Nom(1..LongNom),Droits);
   end Faire_Touch;

   procedure Faire_Modif_Taille is
   begin
      null;
   end Faire_Modif_Taille;

   procedure Faire_Cd is
   Chemin  : String (1..200);
   LongChemin : Natural;
   begin
      Skip_Line;
      Put("Chemin du cd");
      Get_Line(Chemin, LongChemin);
      Cd(Actuel,Chemin(1..LongChemin));
   end Faire_Cd;

   function Choix_Fi(nom : string)return Boolean is
   Fi : Boolean := False;
   point : Character := '.';
   begin
   for J of nom loop
      if J = point then
         Fi := True;
         return Fi;
      end if;
   end loop;
   return Fi;
   end Choix_Fi;

procedure Faire_Trouver_El is
   est_fichier : Boolean;
   nom : String (1 .. 200);
   L_nom : Natural;
   Fichier : P_Fichier := null;
   Dossier : P_Dossier := null;
begin
   Skip_Line;
   Put("Nom de l'élément dans l'arborescence (ajoutez l'extension si c'est un fichier) : ");
   Get_Line(nom, L_nom);

   est_fichier := Choix_Fi(nom(1 .. L_nom));

   if est_fichier then
      Fichier := Trouver_Fi(nom(1 .. L_nom), Racine'Access);
      if Fichier /= null then
         Put_Line("=== Fichier trouvé ===");
         Put_Line("Nom    : " & To_String(Fichier.all.Nom));
         Put_Line("Taille : " & Integer'Image(Fichier.all.Taille));
         Put_Line("Droits : " & Integer'Image(Fichier.all.Droits));
      else
         Put_Line("Fichier non trouvé.");
      end if;

   else
      Dossier := Trouver_Dos(nom(1 .. L_nom), Racine'Access);

      if Dossier /= null then
         Put_Line("=== Dossier trouvé ===");
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
end Faire_Trouver_El;

procedure Faire_Supprimer is
nom : String (1 .. 200);
L_nom : Natural;
begin
Skip_Line;
Put_Line("Quel est le chemin du fichier à supprimer");
Get_Line(nom, L_nom);
Rm(nom(1..L_nom));
end Faire_Supprimer;

procedure Faire_Copie is
Src : string(1..200);
L_Src : Natural;

Dst : string(1..200);
L_Dst : Natural;

Nn:string(1..200);
L_Nn : Natural;
begin
Skip_Line;
Put_Line("Quel est le fichier a copier ");
Get_Line(Src, L_Src);

Put_Line("Quelle est la destination du fichier ");
Get_Line(Dst,L_Dst);

Put_Line("Quel est le nom de votre fichier (tapez rien si non)");
Get_Line(Nn, L_Nn);

Cp(Actuel.all,Src(1..L_Src),Dst(1..L_Src),Nn(1..L_Nn));

end Faire_Copie;



procedure Faire_Mv is
Src : string(1..200);
L_Src : Natural;

Dst : string(1..200);
L_Dst : Natural;

Nn:string(1..200);
L_Nn : Natural;
begin
Skip_Line;
Put_Line("Quel est le fichier a bouger ");
Get_Line(Src, L_Src);

Put_Line("Quelle est la destination du fichier ");
Get_Line(Dst,L_Dst);

Put_Line("Quel est le nom de votre fichier (tapez rien si non)");
Get_Line(Nn, L_Nn);

Mv(Actuel.all,Src(1..L_Src),Dst(1..L_Src),Nn(1..L_Nn));
end Faire_Mv;

procedure Faire_Tar is
begin
Skip_Line;
Tar;
Put_Line("Dossier courant archivé");
end Faire_Tar;

   procedure Faux_Main is
   choix : Integer;
   begin
    while True loop
      begin
         Afficher_Banniere_Main;
         Get(choix);
         case choix is 
            when 1 =>
               Menu;
               exit;
            when 2 =>
               Cmd;
               exit;
            when 3 =>
               raise Sortie;
            when others =>
               raise Bad_Choice_Number;
         end case;
         
         exception
            when Bad_Choice_Number =>
               Put("Mauvais choix de nombre !");
            when Data_error =>
               Put("Veillez entrer un nombre !");
      end;
   end loop;
   end Faux_Main;

   procedure Afficher_Banniere_Menu is
   begin
      Put_Line ("+-----------------------------------------------+");
      Put_Line ("|      Bienvenue dans le SGF mode menu          |");
      Put_Line ("|-----------------------------------------------|");
      Put_Line ("|   1. Créer un SGF                             |");
      Put_Line ("|   2. Créer un dossier (mkdir)                 |");
      Put_Line ("|   3. Créer un fichier (touch)                 |");
      Put_Line ("|   4. Changer de répertoire (cd)               |");
      Put_Line ("|   5. Afficher le répertoire (ls)              |");
      Put_Line ("|   6. Afficher le chemin (pwd)                 |");
      Put_Line ("|   7. Modifier la taille                       |");
      Put_Line ("|   8. Afficher l'espace restant sur le disque  |");
      Put_Line ("|   9. Trouver un élément                       |");
      Put_Line ("|   10. Supprimer un élément                    |");
      Put_Line ("|   11. Copier un élément                       |");
      Put_Line ("|   12. Deplacer un élément                     |");
      Put_Line ("|   13. Archiver le répertoire courant          |");
      Put_Line ("|   14. Revenir au chois de mode                |");
      Put_Line ("|                                               |");
      Put_Line ("|   Entrez votre choix (1-13)                   |");
      Put_Line ("+-----------------------------------------------+");
   end Afficher_Banniere_Menu;

   procedure Menu is
   choix :integer;
   begin
   while True loop
      begin
      Afficher_Banniere_Menu;
      Get(choix);
      case choix is
         when 1 =>
            Faire_Init;
         when 2 =>
            Faire_Dossier;
         when 3 =>
            Faire_Touch;
         when 4 =>
            Faire_Cd;
         when 5 =>
            Ls;
            New_Line;
         when 6 =>
            Pwd;
            New_Line;
         when 7 => 
            Faire_Modif_Taille;
         when 8 =>
            Put_Line(Long_Integer'Image(disque_restant));
         when 9 =>
            Faire_Trouver_El;
         when 10 =>
            Faire_Supprimer;
         when 11 => 
            Faire_Copie;
         when 12 =>
            Faire_Mv;
         when 13 =>
            Faire_Tar;
         when 14=>
            Faux_Main;
         when others =>
            raise Bad_Choice_Number;
      end case;
      exception
         when Bad_Choice_Number =>
            Put("Mauvais choix de nombre !");
            New_Line;
            Skip_Line;
         when Data_error =>
               Put("Veillez entrer un nombre !");
               Skip_Line;
               New_Line;
         when Constraint_Error =>
         Put_Line("Mauvais arguments !");

         when Uninitialized_SGF =>
         Put_Line("SGF non initialisé :( ");

         when Incorect_Argument_Number => 
         Put_Line("Nombre d'argument incorecte !");
      end;
      end loop;

   exception
   when Sortie =>
   return;
   end Menu;

   
end Affichage;