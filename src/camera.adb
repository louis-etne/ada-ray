package body Camera is

   function To_Cartesian (Camera : Camera_Type) return Math.Vector.Vector_Type is
      use Math;
      use Math.Angle_Elementary_Functions;
   begin
      return V : constant Math.Vector.Vector_Type :=
        (X => Scalar_Type (Camera.R * Cos (Camera.Theta) * Cos (Camera.Phi)),
         Y => Scalar_Type (Camera.R * Sin (Camera.Theta) * Cos (Camera.Phi)),
         Z => Scalar_Type (Camera.R * Sin (Camera.Phi)));
   end To_Cartesian;

   function Get_Transform_Matrix (Camera : Camera_Type) return Math.Matrix.Matrix_Type is
      use Math;
      use Math.Angle_Elementary_Functions;

      Position : constant Math.Vector.Vector_Type := Camera.To_Cartesian;
   begin
      return M : constant Math.Matrix.Matrix_Type :=
        (1 => (1 => -Scalar_Type (Sin (Camera.Theta)),
               2 => Scalar_Type (Cos (Camera.Theta)),
               3 => 0.0,
               4 => 0.0),
         2 => (1 => Scalar_Type (Cos (Camera.Theta)) * Scalar_Type (Sin (Camera.Phi)),
               2 => Scalar_Type (Sin (Camera.Theta)) * Scalar_Type (Sin (Camera.Phi)),
               3 => -Scalar_Type (Cos (Camera.Phi)),
               4 => 0.0),
         3 => (1 => Scalar_Type (Cos (Camera.Theta)) * Scalar_Type (Cos (Camera.Phi)),
               2 => Scalar_Type (Sin (Camera.Theta)) * Scalar_Type (Cos (Camera.Phi)),
               3 => Scalar_Type (Sin (Camera.Phi)),
               4 => 0.0),
         4 => (1 => Position.X,
               2 => Position.Y,
               3 => Position.Z,
               4 => 1.0));
   end Get_Transform_Matrix;

   function Ray_Trace
     (Origin      : Math.Vector.Vector_Type;
      Unit        : Math.Vector.Vector_Type;
      Balls       : Ball.Ball_Array_Type;
      Height      : Math.Scalar_Type;
      Coefficient : Math.Scalar_Type;
      Limit       : Integer)
      return Material.Color_Type
   is
      use Math;
      use Math.Scalar_Elementary_Functions;
      use Math.Vector;
      use Material;

      -- Signed distance
      Distance_To_Plane : constant Math.Scalar_Type := -(Origin.Z + Height) / Unit.Z;
      Index : Integer := 0;
      Distance : Math.Scalar_Type := 0.0;
   begin
      Balls_Loop:
      for Cursor in Balls'Range loop
         declare
            B : Ball.Ball_Type renames Balls (Cursor);

            Difference : constant Math.Vector.Vector_Type := Origin - B.Origin;
            Discriminant : constant Math.Scalar_Type :=
              Unit.Dot (Difference) ** 2 + B.Radius ** 2 - Difference.Dot (Difference);
         begin
            if Discriminant < 0.0 then
               goto Continue;
            end if;

            Distance := -Unit.Dot (Difference) - Sqrt (Discriminant);

            if Distance <= 0.0 then
               goto Continue;
            end if;

            Index := Cursor;
            exit Balls_Loop;
            <<Continue>>
         end;
      end loop Balls_Loop;

      if Index = 0 then -- Ray didn't hit a ball
         if Unit.Z > 0.0 then
            return Color_Type'First; -- The ray hits the sky
         else -- The ray hits the floor
            declare
               Origin_Shift : constant Math.Vector.Vector_Type :=
                 (X => Origin.X + Distance_To_Plane * Unit.X,
                  Y => Origin.Y + Distance_To_Plane * Unit.Y,
                  Z => Origin.Z + Distance_To_Plane * Unit.Z);

               Unit_Shift : constant Math.Vector.Vector_Type :=
                 (X => Unit.X,
                  Y => Unit.Y,
                  Z => -Unit.Z);
            begin
               if Integer (Scalar_Type'Floor (Origin_Shift.X) + Scalar_Type'Floor (Origin_Shift.Y)) mod 2 = 0 then
                  return
                    Color_Type ((1.0 - Coefficient) * Scalar_Type(Color (1.0 / (1.0 + Distance_To_Plane / 10.0)))
                                + Coefficient * Scalar_Type (Ray_Trace (Origin      => Origin_Shift,
                                                                        Unit        => Unit_Shift,
                                                                        Balls       => Balls,
                                                                        Height      => Height,
                                                                        Coefficient => Coefficient,
                                                                        Limit       => Limit - 1)));
               else
                  return Color_Type'First;
               end if;
            end;
         end if;
      end if;

      -- Check if ray hits the floor
      if Unit.Z < 0.0 and then Distance > Distance_To_Plane then
         declare
            Tx : constant Math.Scalar_Type := Scalar_Type'Floor (Origin.X + Distance_To_Plane * Unit.X);
            Ty : constant Math.Scalar_Type := Scalar_Type'Floor (Origin.Y + Distance_To_Plane * Unit.Y);
         begin
            return Color_Type (Integer (Tx + Ty) mod 2);
         end;
      end if;

      -- Then ray hits a ball
      if Limit = 0 then
         return Balls (Index).Color;
      end if;

      declare
         Origin_Shift : constant Math.Vector.Vector_Type :=
           (X => Origin.X + Distance * Unit.X,
            Y => Origin.Y + Distance * Unit.Y,
            Z => Origin.Z + Distance * Unit.Z);

         Normal : Math.Vector.Vector_Type := Normalize (Origin_Shift - Balls (Positive (Index)).Origin);
         K : constant Math.Scalar_Type := 2.0 * Unit.Dot (Normal);
         Unit_Shift : Math.Vector.Vector_Type;

         Reflect : constant Math.Scalar_Type := Scalar_Type (Balls (Index).Reflectivity);
      begin
         Normal := Normal * K;
         Unit_Shift := Unit - Normal;

         return Color_Type ((1.0 - Reflect) * Scalar_Type (Balls (Index).Color)
                            + Reflect * Scalar_Type (Ray_Trace (Origin      => Origin_Shift,
                                                                Unit        => Unit_Shift,
                                                                Balls       => Balls,
                                                                Height      => Height,
                                                                Coefficient => Coefficient,
                                                                Limit       => Limit - 1)));
      end;
   end Ray_Trace;

end Camera;
