with Tarmi.Symbols; use Tarmi.Symbols;
with Tarmi.Combiners; use Tarmi.Combiners;

package body Tarmi.Evaluation is

   function Eval (Form : Datum; Env : Environment) return Datum is
      Form_L : Datum := Form;
      Env_L : Environment := Env;
   begin
      Tail_Eval: loop
         if Form_L.all in Pair_R then
            declare
               Operator : Datum := Pair(Form_L).First;
               Comb : Combiner := Combiner (Eval (Operator, Env_L));  -- may raise exception
               Operand_Tree : Datum := Pair(Form_L).Second;
            begin
               if Comb.all in Operative_R then
                  declare
                     Oper : Operative := Operative (Comb);
                     C_Env : Environment := Child_Environment (Oper.Static_Env);
                  begin
                     Match_Bind (C_Env, Oper.Param_Tree_Formals, Operand_Tree);
                     Bind (C_Env, Oper.Dyn_Env_Formal, Datum (Env_L));
                     Env_L := C_Env;
                     Form_L := Oper.Body_Form;
                     -- Tail-Eval the body in the extended environment
                  end;
               else -- Applicative
                  declare
                     function Eval_Ops (Ops : Datum) return Datum is
                     begin
                        if Ops.all in Pair_R then
                           return new Pair_R'(Eval (Pair(Ops).First, Env_L),
                                              Eval_Ops (Pair(Ops).Second));
                        elsif Ops = Nil then
                           return Nil;
                        else
                           -- TODO: some error, not a proper list, Kernel Language violation
                           raise Constraint_Error;
                        end if;
                     end Eval_Ops;
                  begin
                     -- TODO: Make more efficient by not allocating a new pair.
                     Form_L := new Pair_R'(Datum (Applicative(Comb).Underlying),
                                           Eval_Ops (Operand_Tree));
                     -- Tail-Eval the derived form in same environment
                  end;
               end if;
            end;
         elsif Form_L.all in Symbol_R then
            return Lookup (Symbol (Form_L), Env_L);
         else
            return Form_L;
         end if;
      end loop Tail_Eval;
   end Eval;

end Tarmi.Evaluation;
