-- TODO: Think about memory management issues w.r.t. strings
--  and symbols used in the symbol table.  What about string
--  pointers given as arguments to Interned?
--  Newly-allocated strings in other version of Interned?
--  Newly-allocated symbols when a name not already
--  interned?  What is the portable semantics w.r.t. master
--  completion and finalization and ownership?

with Ada.Strings.Hash;

package body Tarmi.Symbols is

   function Hash_String (Key : String_Type_A) return Hash_Type is
   begin
      return Ada.Strings.Hash (Key.all) ;
   end Hash_String ;

   function Keys_Equal (Left, Right : String_Type_A) return Boolean is
   begin
      return Left.all = Right.all ;
   end Keys_Equal ;

   function Interned (Name : String_Type_A) return Symbol is
      use type Hashed_Maps.Cursor ;
      C : Hashed_Maps.Cursor := Hashed_Maps.Find (Symbol_Table, Name) ;
   begin
      if C = Hashed_Maps.No_Element then
         declare
            S : Symbol := new Symbol_R'(Name'Length, Name.all) ;
         begin
            Hashed_Maps.Insert (Symbol_Table, Name, S) ;
            return S ;
         end ;
      else
         return Hashed_Maps.Element (C) ;
      end if ;
      -- TODO: Could this be faster by using 4-arg Hashed_Maps.Insert ?
      --       I think that would do only one hash, whereas now it's doing two.
   end Interned ;

   function Interned (Name : String_Type) return Symbol is
      S : String_Type_A := new String_Type'(Name) ;
   begin
      return Interned (S) ;
   end Interned ;

--begin
   --Hashed_Maps.Reserve_Capacity (Symbol_Table, 1000) ;  -- TODO: best size
end Tarmi.Symbols ;
