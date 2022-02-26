with Math.Matrix;

package Math.Vector is

   -- Type defintions
   type Vector_Type is tagged record
      X : Scalar_Type := 0.0;
      Y : Scalar_Type := 0.0;
      Z : Scalar_Type := 0.0;
   end record;

   -- Operators
   function "+" (Left, Right : Vector_Type) return Vector_Type;
   function "-" (Left, Right : Vector_Type) return Vector_Type;
   function "*" (Left : Vector_Type; Right : Scalar_Type) return Vector_Type;
   function "*" (Left : Scalar_Type; Right : Vector_Type) return Vector_Type;

   -- Mathematical functions
   function Dot (Left, Right : Vector_Type) return Scalar_Type;
   procedure Normalize (V : in out Vector_Type);
   function Normalize (V : in Vector_Type) return Vector_Type;
   function Apply_Transform_Matrix (V : Vector_Type; M : Matrix.Matrix_Type) return Vector_Type;

   -- Debug
   function Debug (V : Vector_Type) return String;

   -- Constant values
   Origin : constant Vector_Type := (0.0, 0.0, 0.0);

end Math.Vector;
