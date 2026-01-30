with SGF; use SGF;
package Affichage_cmd is


procedure Cmd;
-- pre  : aucune
-- post : commande traitée

procedure Trouver_Commande(Commandes : in String);
-- pre  : Commandes /= ""
-- post : commande exécutée ou message d’erreur

procedure Cmd_Faire_Mkdir(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 4, paramètres valides
-- post : dossier créé

procedure Cmd_Faire_Touch(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 4, paramètres valides
-- post : fichier créé

procedure Cmd_Faire_Cd(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 2, chemin valide
-- post : répertoire changé

procedure Cmd_Faire_Ls(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 1
-- post : contenu affiché

procedure Cmd_Faire_Pwd(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 1
-- post : chemin affiché

procedure Cmd_Faire_Find(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 2, nom valide
-- post : élément trouvé ou message

procedure Cmd_Faire_Mv(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 4, paramètres valides
-- post : élément déplacé

procedure Cmd_Faire_Cp(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 4, paramètres valides
-- post : élément copié

procedure Cmd_Faire_Rm(Liste_param : Liste_U_String ; Nb_El : Integer);
-- pre  : Nb_El = 2, chemin valide
-- post : élément supprimé



Bad_Argument : exception;
Incorect_Argument_Number : exception;
end Affichage_cmd;