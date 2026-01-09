package SGF is

   type Indexeur is private;
   type Droits is (Lecture, Ecriture, Execution, Aucun);
   type Liste_Droits is array (Positive range <>) of Droits;

   type T_Fichier;
   type T_Dossier;

   type P_Fichier is access all T_Fichier;
   type P_Dossier is access all T_Dossier;

   type T_Fichier is record
      Nom    : String;
      Taille : Integer;
      Droits : Liste_Droits (1 .. 3);
   end record;

   type Liste_Contenu;
   type P_Liste_Contenu is access all Liste_Contenu;

   type Liste_Contenu is record
      Est_Fichier : Boolean;
      Fichier     : P_Fichier;
      Dossier     : P_Dossier;
      Suivant     : P_Liste_Contenu;
   end record;

   type T_Dossier is record
      Nom           : String;
      Droits        : Liste_Droits (1 .. 3);
      Dossier_Parent : P_Dossier;
      Contenu       : P_Liste_Contenu;
   end record;

   -- Initialisation du SGF (formatage)
   procedure Init_SGF (Dos : out T_Dossier);
   -- pre  : Dossier non initialisé
   -- post : Dossier racine vide créé

   -- Affichage du répertoire courant
   procedure Pwd (Dos : in T_Dossier);
   -- pre  : Dossier initialisé
   -- post : Affiche le répertoire courant


   -- Création d’un fichier
   procedure Touch (Dos : in out T_Dossier; Fi : out T_Fichier;
                    Nom : in String; Droits : in Liste_Droits);
   -- pre  : Dossier initialisé
   -- post : Ajoute un fichier au contenu du dossier

   -- Modification de la taille d’un fichier
   procedure Modif_Taille (Dos : in T_Dossier; Fichier : in out T_Fichier;
                           Taille : in Integer);
   -- pre  : Fichier et dossier existent
   -- post : Taille modifiée

   -- Création d’un répertoire
   procedure Mkdir (Dos : in out T_Dossier; Rep : out T_Dossier;
                    Nom : in String; Droits : in Liste_Droits;
                    Parent : in P_Dossier);
   -- pre  : Dossier initialisé
   -- post : Ajoute un dossier vide

   -- Changement du répertoire courant
   procedure Cd (Dos : in out T_Dossier; Repertoire : in String);
   -- pre  : Dossier initialisé
   -- post : Change le répertoire courant

   -- Affichage du contenu d’un dossier (ls)
   procedure Ls (Dos : in T_Dossier; Chemin : in String);
   -- pre  : Dossier initialisé
   -- post : Affiche le contenu du répertoire désigné

   -- Affichage récursif (ls -r)
   procedure Lsr (Dos : in T_Dossier);
   -- pre  : Dossier initialisé
   -- post : Affiche récursivement tous les fichiers et sous-répertoires

   -- Suppression d’un fichier
   procedure Rm (Dos : in out T_Dossier; Index : in Indexeur);
   -- pre  : Index valide
   -- post : Fichier supprimé
   -- exception : Dossier inexistant

   -- Suppression récursive d’un dossier
   procedure Rmr (Dos : in out T_Dossier; Chemin : in String);
   -- pre  : Dossier initialisé
   -- post : Dossier et sous-dossiers supprimés

   -- Déplacement ou renommage d’un fichier
   procedure Mv (Dos : in out T_Dossier; Dest : in String; Nom : in String);
   -- pre  : Dossier initialisé
   -- post : Fichier déplacé ou renommé

   -- Copie récursive d’un fichier ou dossier
   procedure Cpr (Dos : in T_Dossier; Element : in String; Destination : in String);
   -- pre  : Dossier initialisé, élément existant
   -- post : Copie effectuée

private
   type Indexeur is new Integer;
end SGF;

