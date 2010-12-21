with Tarmi.Environments; use Tarmi.Environments;

package Tarmi.Combiners is

   type Combiner_R is abstract new Datum_R with null record;
   type Combiner is not null access constant Combiner_R'Class;

   type Operative_R is new Combiner_R with
      record
         Param_Tree_Formals : Datum;
         Dyn_Env_Formal : Datum;
         Static_Env : Environment;
         Body_Form : Datum;
      end record;
   type Operative is not null access constant Operative_R;

   type Applicative_R is new Combiner_R with
      record
         Underlying : Combiner;
      end record;
   type Applicative is not null access constant Applicative_R;

end Tarmi.Combiners;
