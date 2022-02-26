with Ada.Strings.Unbounded;

package body Math.Matrix is

   function Invert (M : Matrix_Type) return Matrix_Type is
      A3434 : constant Scalar_Type := M (3, 3) * M (4, 4) - M (3, 4) * M (4, 3);
      A2434 : constant Scalar_Type := M (3, 2) * M (4, 4) - M (3, 4) * M (4, 2);
      A2334 : constant Scalar_Type := M (3, 2) * M (4, 3) - M (3, 3) * M (4, 2);
      A1434 : constant Scalar_Type := M (3, 1) * M (4, 4) - M (3, 4) * M (4, 1);
      A1334 : constant Scalar_Type := M (3, 1) * M (4, 3) - M (3, 3) * M (4, 1);
      A1234 : constant Scalar_Type := M (3, 1) * M (4, 2) - M (3, 2) * M (4, 1);
      A3424 : constant Scalar_Type := M (2, 3) * M (4, 4) - M (2, 4) * M (4, 3);
      A2424 : constant Scalar_Type := M (2, 2) * M (4, 4) - M (2, 4) * M (4, 2);
      A2324 : constant Scalar_Type := M (2, 2) * M (4, 3) - M (2, 3) * M (4, 2);
      A3423 : constant Scalar_Type := M (2, 3) * M (3, 4) - M (2, 4) * M (3, 3);
      A2423 : constant Scalar_Type := M (2, 2) * M (3, 4) - M (2, 4) * M (3, 2);
      A2323 : constant Scalar_Type := M (2, 2) * M (3, 3) - M (2, 3) * M (3, 2);
      A1424 : constant Scalar_Type := M (2, 1) * M (4, 4) - M (2, 4) * M (4, 1);
      A1324 : constant Scalar_Type := M (2, 1) * M (4, 3) - M (2, 3) * M (4, 1);
      A1423 : constant Scalar_Type := M (2, 1) * M (3, 4) - M (2, 4) * M (3, 1);
      A1323 : constant Scalar_Type := M (2, 1) * M (3, 3) - M (2, 3) * M (3, 1);
      A1224 : constant Scalar_Type := M (2, 1) * M (4, 2) - M (2, 2) * M (4, 1);
      A1223 : constant Scalar_Type := M (2, 1) * M (3, 2) - M (2, 2) * M (3, 1);
      
      Determinant : constant Scalar_Type := 1.0 / 
        (M (1, 1) * (M (2, 2) * A3434 - M (2, 3) * A2434 + M (2, 4) * A2334)
                                                   -  M (1, 2) * (M (2, 1) * A3434 - M (2, 3) * A1434 + M (2, 4) * A1334)
                                                   +  M (1, 3) * (M (2, 1) * A2434 - M (2, 2) * A1434 + M (2, 4) * A1234)
                                                   -  M (1, 4) * (M (2, 1) * A2334 - M (2, 2) * A1334 + M (2, 3) * A1234));
   begin
      return Result : constant Matrix_Type := 
        (1 => (1 => Determinant * (+ (M (2, 2) * A3434 - M (2, 3) * A2434 + M (2, 4) * A2334)),
               2 => Determinant * (- (M (1, 2) * A3434 - M (1, 3) * A2434 + M (1, 4) * A2334)),
               3 => Determinant * (+ (M (1, 2) * A3424 - M (1, 3) * A2424 + M (1, 4) * A2324)),
               4 => Determinant * (- (M (1, 2) * A3423 - M (1, 3) * A2423 + M (1, 4) * A2323))),
         2 => (1 => Determinant * (- (M (2, 1) * A3434 - M (2, 3) * A1434 + M (2, 4) * A1334)),
               2 => Determinant * (+ (M (1, 1) * A3434 - M (1, 3) * A1434 + M (1, 4) * A1334)),
               3 => Determinant * (- (M (1, 1) * A3424 - M (1, 3) * A1424 + M (1, 4) * A1324)),
               4 => Determinant * (+ (M (1, 1) * A3423 - M (1, 3) * A1423 + M (1, 4) * A1323))),
         3 => (1 => Determinant * (+ (M (2, 1) * A2434 - M (2, 2) * A1434 + M (2, 4) * A1234)),
               2 => Determinant * (- (M (1, 1) * A2434 - M (1, 2) * A1434 + M (1, 4) * A1234)),
               3 => Determinant * (+ (M (1, 1) * A2424 - M (1, 2) * A1424 + M (1, 4) * A1224)),
               4 => Determinant * (- (M (1, 1) * A2423 - M (1, 2) * A1423 + M (1, 4) * A1223))),
         4 => (1 => Determinant * (- (M (2, 1) * A2334 - M (2, 2) * A1334 + M (2, 3) * A1234)),
               2 => Determinant * (+ (M (1, 1) * A2334 - M (1, 2) * A1334 + M (1, 3) * A1234)),
               3 => Determinant * (- (M (1, 1) * A2324 - M (1, 2) * A1324 + M (1, 3) * A1224)),
               4 => Determinant * (+ (M (1, 1) * A2323 - M (1, 2) * A1323 + M (1, 3) * A1223))));
   end Invert;
   
   function Debug (M : Matrix_Type) return String is
      use Ada.Strings.Unbounded;
      
      S : Ada.Strings.Unbounded.Unbounded_String;
   begin
      for Row in M'Range (1) loop
         for Col in M'Range (2) loop
            S := S & M (Row, Col)'Img & " ";
         end loop;
         
         S := S & ASCII.LF;
      end loop;
      
      return Ada.Strings.Unbounded.To_String (S);
   end Debug;

end Math.Matrix;
