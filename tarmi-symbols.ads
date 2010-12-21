with Ada.Containers; use Ada.Containers;
with Ada.Containers.Hashed_Maps;

package Tarmi.Symbols is

   type Symbol_R (N : Positive) is new Datum_R with
      record
         Name : String_Type (1 .. N);
      end record;
   type Symbol is not null access constant Symbol_R;

   type String_Type_A is not null access constant String_Type;

   function Hash_String (Key : String_Type_A) return Hash_Type;

   function Keys_Equal (Left, Right : String_Type_A) return Boolean ;

   package Hashed_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type => String_Type_A,
      Element_Type => Symbol,
      Hash => Hash_String,
      Equivalent_Keys => Keys_Equal);

   Symbol_Table : Hashed_Maps.Map ;

   function Interned (Name : String_Type_A) return Symbol;
   function Interned (Name : String_Type) return Symbol;

end Tarmi.Symbols;
