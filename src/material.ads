with Math;

package Material is

   -- Type defintions
   type Color_Type is new Math.Scalar_Type range 0.0 .. 1.0;        -- 0 is black and 1 is white
   type Reflectivity_Type is new Math.Scalar_Type range 0.0 .. 1.0; -- 0 is no reflections and 1 is a perfect mirror

   -- Functions
   function Color (S : Math.Scalar_Type) return Color_Type;
   function Reflectivity (S : Math.Scalar_Type) return Reflectivity_Type;
   
end Material;
