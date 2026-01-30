with SGF; use SGF;
with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;    use Ada.Integer_Text_IO;
with Affichage;              use Affichage;
with Affichage_cmd;          use Affichage_cmd;
with Disque;                 use Disque;

procedure Test is

   Fi : T_Fichier;

   -- Procédure pour simplifier l'affichage des tests
   procedure Banniere (Titre : String) is
   begin
      New_Line;
      Put_Line("=======================================");
      Put_Line(Titre);
      Put_Line("=======================================");
   end Banniere;

begin
   ------------------------------------------------------------------
   Banniere("TEST 1 : Initialisation du SGF");
   begin
      -- Initialisation du SGF
      Init_SGF;
      Put_Line("Init_SGF : OK");
      Pwd;
   exception
      when Uninitialized_SGF =>
         Put_Line("Erreur : SGF non initialisé");
      when others =>
         Put_Line("Erreur inconnue dans Init_SGF");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 2 : Création des dossiers à la racine");
   begin
      -- Creation de dossiers
      Mkdir("/home", "home", 2#111#, Actuel);
      Mkdir("/etc",  "etc",  2#111#, Actuel);
      Mkdir("/opt",  "opt",  2#111#, Actuel);
      Put_Line("Création des dossiers : OK");
      Ls;
   exception
      when No_Remaining_Place =>
         Put_Line("Erreur : espace disque insuffisant");
      when Uninitialized_SGF =>
         Put_Line("Erreur : SGF non initialisé");
      when others =>
         Put_Line("Erreur inconnue lors de Mkdir");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 3 : Navigation avec Cd");
   begin
   -- changement de dossier, vérification avec Pwd
      Cd(Actuel, "/home");
      Put_Line("Cd /home : OK");
      Pwd;
   exception
      when Uninitialized_SGF =>
         Put_Line("Erreur : SGF non initialisé");
      when others =>
         Put_Line("Erreur inconnue dans Cd");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 4 : Création de sous-dossiers et fichiers");
   begin
      Mkdir("/home/user1", "user1", 2#111#, Actuel);
      Mkdir("/home/n7",    "n7",    2#111#, Actuel);
      Mkdir("/home/user2", "user2", 2#111#, Actuel);
      Touch(Fi, 30, "Fichier1", 2#111#);
      Put_Line("Sous-dossiers et fichier créés : OK");
      Ls;
   exception
      when No_Remaining_Place =>
         Put_Line("Erreur : espace disque insuffisant");
      when Uninitialized_SGF =>
         Put_Line("Erreur : SGF non initialisé");
      when others =>
         Put_Line("Erreur inconnue lors de Touch/Mkdir");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 5 : Retour à la racine");
   begin
      -- déplacement à dans l'arborescence
      Cd(Actuel, "..");
      Put_Line("Cd .. : OK");
      Pwd;
   exception
      when others =>
         Put_Line("Erreur lors du retour à la racine");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 6 : Ls récursif depuis la racine");
   begin
      Lsr;
      Put_Line("Lsr (racine) : OK");
   exception
      when others =>
         Put_Line("Erreur lors de Lsr");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 7 : Recherche de chemin valide");
   declare
      -- test de la fonction intermédiaire de recherche de chemin
      Ptr : P_Liste_Contenu;
   begin
      Ptr := Recherche_chemin("/home");
      if Ptr /= null then
         Put_Line("Recherche_chemin /home : OK");
      else
         Put_Line("Recherche_chemin /home : ECHEC");
      end if;
   exception
      when others =>
         Put_Line("Erreur lors de Recherche_chemin");
   end;

   ------------------------------------------------------------------
   Banniere("TEST 8 : Recherche de chemin invalide");
   declare
      Ptr : P_Liste_Contenu;
   begin
      Ptr := Recherche_chemin("/inexistant");
      if Ptr = null then
         Put_Line("Chemin invalide correctement détecté");
      else
         Put_Line("Erreur : chemin invalide accepté");
      end if;
   exception
      when others =>
         Put_Line("Erreur inattendue dans Recherche_chemin");
   end;

   ------------------------------------------------------------------
   Banniere("FIN DES TESTS");

end Test;