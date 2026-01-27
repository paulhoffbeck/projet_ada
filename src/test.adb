with SGF; use SGF;
with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Affichage; use Affichage;
with Affichage_cmd; use Affichage_cmd;
with Disque; use Disque;
procedure Test is

   procedure Banniere (Titre : String) is
   begin
      Put_Line("");
      Put_Line("=======================================");
      Put_Line(Titre);
      Put_Line("=======================================");
   end Banniere;

begin
   Banniere("TEST 1 : Initialisation du SGF");

   begin
      Init_SGF;
      Put_Line("Init_SGF OK");
      Pwd;
      Mkdir("/home", "home", 111, Actuel);
      Mkdir("/etc", "etc", 111, Actuel);
      Mkdir("/opt", "opt", 111, Actuel);
      Lsr;
      Cd (Actuel, "/home");
      Pwd;
      Mkdir("/home/user1", "user1", 111, Actuel);
      Mkdir("/home/n7", "n7", 111, Actuel);
      Mkdir("/home/user2", "user2", 111, Actuel);
      Lsr;
      Cd(Actuel, "..");
      Pwd;
      Lsr;
      Lsr("/home");

   --exception
   --   when E : others =>
   --      Put_Line("Erreur Init_SGF : " & Uninitialized_SGF(E));
   end;
end Test;