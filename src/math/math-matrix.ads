package Math.Matrix is

   -- Type defintions
   type Matrix_Index_Type is range 1 .. 4;
   type Matrix_Type is array (Matrix_Index_Type, Matrix_Index_Type) of Scalar_Type;

   function Invert (M : Matrix_Type) return Matrix_Type;
   
   -- Debug
   function Debug (M : Matrix_Type) return String;
end Math.Matrix;
