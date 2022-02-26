package body Math.Vector is

   function "+" (Left, Right : Vector_Type) return Vector_Type is
   begin
      return V : constant Vector_Type :=
        (X => Left.X + Right.X,
         Y => Left.Y + Right.Y,
         Z => Left.Z + Right.Z);
   end "+";

   function "-" (Left, Right : Vector_Type) return Vector_Type is
   begin
      return V : constant Vector_Type :=
        (X => Left.X - Right.X,
         Y => Left.Y - Right.Y,
         Z => Left.Z - Right.Z);
   end "-";

   function "*" (Left : Vector_Type; Right : Scalar_Type) return Vector_Type is
   begin
      return V : constant Vector_Type :=
        (X => Left.X * Right,
         Y => Left.Y * Right,
         Z => Left.Z * Right);
   end "*";

   function "*" (Left : Scalar_Type; Right : Vector_Type) return Vector_Type is
     (Right * Left);

   function Dot (Left, Right : Vector_Type) return Scalar_Type is
   begin
      return S : constant Scalar_Type := (Left.X * Right.X) + (Left.Y * Right.Y) + (Left.Z * Right.Z);
   end Dot;

   procedure Normalize (V : in out Vector_Type) is
      Length : constant Scalar_Type := Scalar_Elementary_Functions.Sqrt (V.X ** 2 + V.Y ** 2 + V.Z ** 2);
   begin
      if Length /= 0.0 then
         V.X := V.X / Length;
         V.Y := V.Y / Length;
         V.Z := V.Z / Length;
      end if;
   end Normalize;

   function Normalize (V : in Vector_Type) return Vector_Type is
      Result : Vector_Type := V;
   begin
      Result.Normalize;
      return Result;
   end;

   function Apply_Transform_Matrix (V : Vector_Type; M : Matrix.Matrix_Type) return Vector_Type is
   begin
      return Result : constant Vector_Type :=
        (X => V.X * M (1, 1) + V.Y * M (2, 1) + V.Z * M (3, 1) + M (4 , 1),
         Y => V.X * M (1, 2) + V.Y * M (2, 2) + V.Z * M (3, 2) + M (4 , 2),
         Z => V.X * M (1, 3) + V.Y * M (2, 3) + V.Z * M (3, 3) + M (4 , 3));
   end Apply_Transform_Matrix;

   function Debug (V : Vector_Type) return String is
   begin
      return "V (" & V.X'Img & "; " & V.Y'Img & "; " & V.Z'Img & ")";
   end Debug;

end Math.Vector;
