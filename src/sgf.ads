with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

--CONTRATS A VERIFIER

package SGF is

   type Liste_U_String is array (Positive range <>) of Unbounded_String;


   type T_Fichier;
   type T_Dossier;

   type P_Fichier is access all T_Fichier;
   type P_Dossier is access all T_Dossier;

   type T_Fichier is record
      Nom    : Unbounded_String;
      Taille : Integer;
      Droits : Integer := 2#000#; -- Droits : read, write, exec 
   end record;

   type T_Liste_Contenu;
   type P_Liste_Contenu is access all T_Liste_Contenu;

   type T_Liste_Contenu is record
      Est_Fichier : Boolean;
      Fichier     : P_Fichier;
      Dossier     : P_Dossier;
      Suivant     : P_Liste_Contenu;
   end record;

   type T_Dossier is record
      Nom           : Unbounded_String;
      Droits        : Integer := 2#000#;
      Dossier_Parent : P_Dossier;
      Contenu       : P_Liste_Contenu;
   end record;

   Actuel : aliased P_Dossier;
   Racine : aliased T_Dossier;
   Uninitialized_SGF : exception;

   -- Initialisation du SGF (formatage)
   procedure Init_SGF;
   -- pre  : Dossier non initialisé
   -- post : Dossier racine vide créé


   -- Affichage du répertoire courant
   procedure Pwd;
   -- pre  : Dossier initialisé
   -- post : Affiche le répertoire courant

   -- Création d’un fichier avec le chemin courant
   procedure Touch (Fi: out T_Fichier; Taille : in Integer; Nom : in String; Droits : in Integer);


   -- Création d’un fichier avec le chemin en paramètre
   procedure Touch (Dos : in out T_Dossier; Fi : out T_Fichier;
                    Nom : in String; Droits : in Integer);
   -- pre  : Dossier initialisé
   -- post : Ajoute un fichier au contenu du dossier

   -- Modification de la taille d’un fichier
   procedure Modif_Taille (Chemin : String; Taille : in Integer; Fichier : out T_Fichier);
   -- pre  : Fichier et dossier existent
   -- post : Taille modifiée

   -- Création d’un répertoire
   procedure Mkdir (Chemin : in String; Nom : in String; Droits : in Integer; Parent : in P_Dossier);
   -- pre  : Dossier initialisé
   -- post : Ajoute un dossier vide
   
   procedure Tar;

   function Recherche_chemin(Chemin : in String) return P_Liste_Contenu;

   -- Changement du répertoire courant
   procedure Cd (Cur : in out P_Dossier ; Repertoire : in String);
   -- pre  : Dossier initialisé
   -- post : Change le répertoire courant

   -- Affichage du contenu du dossier actuel (ls)
   procedure Ls;
   -- pre  : Dossier initialisé
   -- post : Affiche le contenu du répertoire actuel

   -- Affichage du contenu d’un dossier (ls)
   procedure Ls (Chemin : in String);
   -- pre  : Dossier initialisé
   -- post : Affiche le contenu du répertoire désigné

   -- Affichage récursif (ls -r)
   procedure Lsr;
   -- pre  : Dossier initialisé
   -- post : Affiche récursivement tous les fichiers et sous-répertoires du dossier actuel

   -- Affichage récursif (ls -r)
   procedure Lsr (Chemin : in String);
   -- pre  : Dossier initialisé
   -- post : Affiche récursivement tous les fichiers et sous-répertoires du dossier désigné

   -- Suppression d’un fichier
   procedure Rm(chemin : string);
   -- pre  : Index valide
   -- post : Fichier supprimé
   -- exception : Dossier inexistant

   -- Suppression récursive d’un dossier
   procedure Rmr (Dos : in out T_Dossier; Chemin : in String);
   -- pre  : Dossier initialisé
   -- post : Dossier et sous-dossiers supprimés

   -- Déplacement ou renommage d’un fichier
   procedure Mv (Dos : in out T_Dossier; Fichier : in String; Dest : in String; Nom : in String);
   -- pre  : Dossier initialisé
   -- post : Fichier déplacé ou renommé

   -- Copie d’un fichier ou dossier
   procedure Cp (Dos : in T_Dossier; Fichier : in String; Destination : in String ; Nouveau_nom : in string);
   -- pre  : Dossier initialisé, élément existant
   -- post : Copie effectuée

   function Split(chemin : String; symbole : Character) return Liste_U_String;
   -- pre  : Chemin non vide
   -- post : Renvoie une liste de chaînes de caractères correspondant aux éléments du chemin

   function Trouver_El_R (Fichier : Boolean; Dossier: P_Dossier;Nom: String; Precedent : P_Dossier) return P_Dossier;
   function Trouver_Fi(nom : string ; Dossier : P_Dossier) return P_Fichier;
   function Trouver_Dos(nom : string ; Dossier : P_Dossier) return P_Dossier;

end SGF;

