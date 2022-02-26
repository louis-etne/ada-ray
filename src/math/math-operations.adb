package body Math.Operations is

   function Clamp (Value, Min, Max : Scalar_Type) return Scalar_Type is
     (if Value < Min then Min else (if Value > Max then Max else Value));

         end Math.Operations;
