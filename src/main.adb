with Ada.Text_IO;
with Ada.Real_Time;

with Ball;
with Camera;
with Material;
with Math;
with Math.Vector;
with Math.Matrix;

procedure Main is
   use Math;
   use Ada.Real_Time;

   Width  : constant Positive := 800;
   Height : constant Positive := 600;

   Character_Width  : constant Positive := 4;
   Character_Height : constant Positive := 8;

   Width_Ratio : constant Positive := Width / Character_Width;
   Height_Ratio : constant Positive := Height / Character_Height;

   type Natural_String is array (Natural range <>) of Character;
   Palette : constant Natural_String := " .:;~=#0B8%&";

   Balls : constant Ball.Ball_Array_Type (1 .. 3) :=
     (1 => (Origin => (0.0, 0.0, 0.0),
            Radius => 1.0,
            Color  => 1.0,
            Reflectivity => 0.9),
      2 => (Origin => (-3.0, 0.0, 0.0),
            Radius => 0.5,
            Color  => 1.0,
            Reflectivity => 0.7),
      3 => (Origin => (0.0, -3.0, 0.0),
            Radius => 0.5,
            Color  => 1.0,
            Reflectivity => 0.7));

   Cam : Camera.Camera_Type := (R => 1.9, Theta => 0.0, Phi => Math.Pi_Over_2);

   Lag        : Ada.Real_Time.Time_Span;
   Min_Lag    : constant Ada.Real_Time.Time_Span := Ada.Real_Time.Milliseconds (24);
   Start_Time : Ada.Real_Time.Time;
   End_Time   : Ada.Real_Time.Time;

   Screen : String (1 .. ((Width_Ratio + 1) * Height_Ratio));

   procedure Move_Cursor (X, Y: Ada.Text_IO.Count) is
   begin
      Ada.Text_IO.Set_Line (X);
      Ada.Text_IO.Set_Col (Y);
   end;
begin
   Move_Cursor (1, 1);

   loop
      Start_Time := Ada.Real_Time.Clock;

      for Row in 1 .. Height_Ratio loop
         for Col in 1 .. Width_Ratio loop
            declare
               use Math;

               Origin : constant Math.Vector.Vector_Type := Cam.To_Cartesian;
               Cam_Matrix : constant Math.Matrix.Matrix_Type := Cam.Get_Transform_Matrix;

               Unit : Math.Vector.Vector_Type :=
                 (X => -((Scalar_Type (Col - 1 - Width_Ratio / 2) + 0.5)) / Scalar_Type (Width_Ratio / 2),
                  Y =>   (Scalar_Type (Row - 1 - Height_Ratio / 2) + 0.5) / Scalar_Type (Width / Character_Height / 2),
                  Z => -1.0);

               Luminance : Material.Color_Type;

               function Get_Char return Character is
                  Index : constant Natural := Natural (Scalar_Type'Floor (Scalar_Type (Palette'Length - 1) * Scalar_Type (Luminance)));
               begin
                  return Palette (Index);
               end Get_Char;
            begin
               Unit := Unit.Apply_Transform_Matrix (Cam_Matrix);

               Unit.X := Unit.X - Origin.X;
               Unit.Y := Unit.Y - Origin.Y;
               Unit.Z := Unit.Z - Origin.Z;

               Unit.Normalize;

               Luminance := Camera.Ray_Trace
                 (Origin      => Origin,
                  Unit        => Unit,
                  Balls       => Balls,
                  Height      => 2.0,
                  Coefficient => 0.3,
                  Limit       => 5);

               Screen (((Row - 1) * (Width_Ratio + 1) + (Col - 1)) + 1) := Get_Char;
            end;
         end loop;
         Screen ((Row - 1) * (Width_Ratio + 1) + Width_Ratio + 1) := ASCII.LF;
      end loop;

      Ada.Text_IO.Put (Screen);

      End_Time := Ada.Real_Time.Clock;
      Lag := End_Time - Start_Time;

      if Lag < Min_Lag then
         delay Ada.Real_Time.To_Duration (Min_Lag - Lag);
      end if;

      Cam.Theta := Cam.Theta + 0.003 * Math.Pi;

      if Cam.Phi > (-Math.Pi_Over_2 / 8.0) then
         Cam.Phi := Cam.Phi - 0.003 * Math.Pi;
      end if;

   end loop;
end Main;
