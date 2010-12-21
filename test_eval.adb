with Text_IO; use Text_IO;
with Tarmi; use Tarmi;
with Tarmi.Environments; use Tarmi.Environments;
with Tarmi.Evaluation; use Tarmi.Evaluation;
with Tarmi.Symbols; use Tarmi.Symbols;
with Tarmi.Combiners; use Tarmi.Combiners;
use type Tarmi.Datum;

procedure Test_Eval is

   Env : Environment := Make_Environment ((Datum(Interned("foo")), Nil));

   A : Datum := Eval (Nil, Env);

   B : Datum := Eval (Datum(Interned("foo")), Env);

   Op1 : Operative := new Operative_R'(Param_Tree_Formals => Ignore ,
                                       Dyn_Env_Formal => Ignore ,
                                       Static_Env => Env ,
                                       Body_Form => Datum (Interned("foo")) ) ;

   Expr1 : Pair := new Pair_R'(Datum (Op1), Nil) ;

   C : Datum := Eval (Datum (Expr1), Env);

   --  Op2 : Operative_R := (Param_Tree_Formals => Interned("foo") ,
   --                    Dyn_Env_Formal => Ignore ,
   --                    Static_Env => Env ,
   --                    Body_Form =>  ) ;
begin
   Put_Line (Boolean'Image(A = Nil));
   Put_Line (Boolean'Image(B = Nil));
   Put_Line (Boolean'Image(C = Nil));
end Test_Eval;
