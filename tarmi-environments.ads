with Ada.Containers; use Ada.Containers;
with Ada.Containers.Hashed_Maps;
with Tarmi.Symbols; use Tarmi.Symbols;

-- TODO: Support multiple environment parents.

package Tarmi.Environments is

   function Hash_Symbol (S : Symbol) return Hash_Type;

   package Hashed_Maps is new Ada.Containers.Hashed_Maps
     (Key_Type => Symbol,
      Element_Type => Datum,
      Hash => Hash_Symbol,
      Equivalent_Keys => "=");

   type Environment_R is new Datum_R with
      record
         Bindings : Hashed_Maps.Map ;
         Parent : access all Environment_R ;
      end record;
   type Environment is not null access all Environment_R;

   type Bindings_Spec is array (Positive range <>) of Datum;
   function Make_Environment (Bindings : Bindings_Spec) return Environment;
   -- TODO: Remove after development.

   function Child_Environment (Env : Environment) return Environment;

   function Lookup (Name : Symbol; Env : Environment) return Datum;

   procedure Bind (Env : Environment; Name : Datum; Val : Datum);

   procedure Match_Bind (Env : Environment; Param_Tree : Datum; Obj : Datum);

end Tarmi.Environments;
