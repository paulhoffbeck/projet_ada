with SGF; use SGF;
package Affichage_cmd is

--CONTRATS A FAIRE

procedure Cmd;
procedure Trouver_Commande(Commandes : in String);
procedure Cmd_Faire_Mkdir(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Touch(Liste_param : Liste_U_String ; Nb_El : Integer);

procedure Cmd_Faire_Cd(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Ls(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Pwd(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Find(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Mv(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Cp(Liste_param : Liste_U_String ; Nb_El : Integer);
procedure Cmd_Faire_Rm(Liste_param : Liste_U_String ; Nb_El : Integer);

Bad_Argument : exception;
Incorect_Argument_Number : exception;
end Affichage_cmd;