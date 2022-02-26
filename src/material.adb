with Math.Operations;

package body Material is

   use Math;
   use Math.Operations;

   function Color (S : Scalar_Type) return Color_Type is
     (Color_Type (Clamp (S, Scalar_Type (Color_Type'First), Scalar_Type(Color_Type'Last))));

   function Reflectivity (S : Scalar_Type) return Reflectivity_Type is
     (Reflectivity_Type (Clamp (S, Scalar_Type (Reflectivity_Type'First), Scalar_Type(Reflectivity_Type'Last))));

end Material;
