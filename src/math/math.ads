with Ada.Numerics;
with Ada.Numerics.Generic_Elementary_Functions;

package Math is

   -- Type defintions
   type Scalar_Type is new Float;
   type Angle_Type is new Scalar_Type;
   
   -- Package implementations
   package Scalar_Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Scalar_Type);
   package Angle_Elementary_Functions is new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Angle_Type);
   
   -- Constant values
   Pi         : constant Angle_Type := +Ada.Numerics.Pi;
   MPi        : constant Angle_Type := -Pi;
   Pi_Over_2  : constant Angle_Type :=  Pi / 2.0;
   MPi_Over_2 : constant Angle_Type := -Pi_Over_2;
   
end Math;
