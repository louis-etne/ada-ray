with Math.Vector;
with Material;

package Ball is

   type Ball_Type is record
      Origin       : Math.Vector.Vector_Type;
      Radius       : Math.Scalar_Type;
      Color        : Material.Color_Type;
      Reflectivity : Material.Reflectivity_Type;
   end record;

   type Ball_Array_Type is array (Positive range <>) of Ball_Type;

end Ball;
