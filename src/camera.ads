with Ball;
with Material;
with Math;
with Math.Vector;
with Math.Matrix;

package Camera is
   
   -- Type defintions
   subtype Distance_Type    is Math.Angle_Type range 0.0 .. Math.Angle_Type'Last;
   subtype Theta_Angle_Type is Math.Angle_Type;
   subtype Phi_Angle_Type   is Math.Angle_Type range Math.MPi_Over_2 .. Math.Pi_Over_2;

   type Camera_Type is tagged record
      R     : Distance_Type    := 0.0;
      Theta : Theta_Angle_Type := 0.0;
      Phi   : Phi_Angle_Type   := 0.0;
   end record;
   
   -- Functions
   function To_Cartesian (Camera : Camera_Type) return Math.Vector.Vector_Type;
   function Get_Transform_Matrix (Camera : Camera_Type) return Math.Matrix.Matrix_Type;
   
   function Ray_Trace 
     (Origin      : Math.Vector.Vector_Type;
      Unit        : Math.Vector.Vector_Type;
      Balls       : Ball.Ball_Array_Type;
      Height      : Math.Scalar_Type;
      Coefficient : Math.Scalar_Type;
      Limit       : Integer)
      return Material.Color_Type;
   
end Camera;
