with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
package SGF is

   type String_List is array (Natural range <>) of Unbounded_String;


   type Indexeur is private;

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

   -- Initialisation du SGF (formatage)
   procedure Init_SGF;
   -- pre  : Dossier non initialisé
   -- post : Dossier racine vide créé


   -- Affichage du répertoire courant
   procedure Pwd;
   -- pre  : Dossier initialisé
   -- post : Affiche le répertoire courant

   -- Création d’un fichier avec le chemin courant
   procedure Touch (Fi: out T_Fichier; Nom : in String; Droits : in Integer);


 
private
   type Indexeur is new Integer;
end SGF;

