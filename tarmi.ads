-- TODO: Figure-out the memory management issues... is it
--  possible to use only standard Ada facilities, or is an
--  additional GC unavoidable?

package Tarmi is

   type Datum_R is abstract tagged null record;
   type Datum is not null access constant Datum_R'Class;

   type Pair_R is new Datum_R with
      record
         First : Datum;
         Second : Datum;
      end record;
   type Pair is not null access constant Pair_R;

   subtype String_Type is Standard.String;

   Nil : constant Datum;
   Ignore : constant Datum;

   Not_Implemented : exception; -- TODO: remove when development done

private

   type Singleton is new Datum_R with null record;

   Nil_Obj : aliased constant Singleton := (null record);
   Nil : constant Datum := Nil_Obj'Access;

   Ignore_Obj : aliased constant Singleton := (null record);
   Ignore : constant Datum := Ignore_Obj'Access;

end Tarmi;
