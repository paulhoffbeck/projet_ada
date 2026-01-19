with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
package body Affichage_cmd is


procedure Cmd is
Commande  : String (1..200);
LongCommande : Natural;
begin
Skip_Line;
while True loop
Put(">");
Get_Line(Commande,LongCommande);
Trouver_Commande(Commande(1..LongCommande));
end loop;
end Cmd;

procedure Trouver_Commande(Commandes : in String) is
Liste_param : Liste_U_String := Split(Commandes, ' ');
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
exception 
when Constraint_Error =>
Put_Line("Mauvais arguments !");

when Uninitialized_SGF =>
Put_Line("SGF non initialisé :( ");

when Incorect_Argument_Number => 
Put_Line("Nombre d'argument incorecte !");
end Trouver_Commande;

procedure Cmd_Faire_Mkdir(Liste_param : Liste_U_String ; Nb_El : Integer) is
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

procedure Cmd_Faire_Touch(Liste_param : Liste_U_String ; Nb_El : Integer) is
Fi : T_Fichier;
Str : string := To_String(Liste_param(2));
Str2 : string := To_String(Liste_param(3));
Int : Integer := Integer'Value(Str2);
begin

case Nb_El is
when 3 =>
Touch(Fi,Str,Int);
when others =>
raise Incorect_Argument_Number;
end case;
end Cmd_Faire_Touch;

procedure Cmd_Faire_Cd(Liste_param : Liste_U_String ; Nb_El : Integer) is
Str : string := To_String(Liste_param(2));
begin
Cd(Actuel,Str);
end Cmd_Faire_Cd;

procedure Cmd_Faire_Ls(Liste_param : Liste_U_String ; Nb_El : Integer) is
begin
case Nb_El is
when 1 =>
Ls;
New_Line;
when others =>
raise Incorect_Argument_Number;
end case;
end Cmd_Faire_Ls;

procedure Cmd_Faire_Pwd(Liste_param : Liste_U_String ; Nb_El : Integer) is
begin
case Nb_El is
when 1 =>
Pwd;
New_Line;
when others =>
raise Incorect_Argument_Number;
end case;
end Cmd_Faire_Pwd;

end Affichage_cmd;