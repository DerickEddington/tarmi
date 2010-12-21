with System.Storage_Elements ;

package body Tarmi.Environments is

   -- TODO: Make this hash function give a better distribution.
   function Hash_Symbol (S : Symbol) return Hash_Type is
      package SE renames System.Storage_Elements ;
      --use type SE.Integer_Address ;
   begin
      --return Hash_Type (SE.To_Integer (S.all'Address) mod Hash_Type'Modulus) ;
      return Hash_Type (SE.To_Integer (S.all'Address));
   end Hash_Symbol;

   function Make_Environment (Bindings : Bindings_Spec) return Environment is
      E : Environment := new Environment_R ;
      I : Positive := 1;
   begin
      while I < Bindings'Last loop
         Bind (E, Bindings(I), Bindings(I+1));
         I := I + 2;
      end loop;
      return E;
   end Make_Environment;
   -- TODO: Remove after development.

   function Child_Environment (Env : Environment) return Environment is
   begin
      return new Environment_R'(Parent => Env , Bindings => <>);
   end Child_Environment;

   -- TODO: Not-found should not raise Ada exception.
   --       It should signal a Kernel error.
   function Lookup (Name : Symbol; Env : Environment) return Datum is
      use Hashed_Maps;
      C : Cursor := Find (Env.Bindings, Name);
   begin
      if C /= No_Element then
         return Element (C);
      else
         if Env.Parent /= null then
            return Lookup (Name, Environment (Env.Parent));
         else
            -- TODO: Instead, signal Kernel error
            raise Program_Error ;
         end if;
      end if;
   end Lookup;

   procedure Bind (Env : Environment; Name : Datum; Val : Datum) is
   begin
      if Name /= Ignore then
         Hashed_Maps.Include (Env.Bindings, Symbol (Name), Val);
      end if ;
   end Bind;

   -- TODO: Acyclic and no-duplicates checking.
   procedure Match_Bind (Env : Environment; Param_Tree : Datum; Obj : Datum) is
   begin
      if Param_Tree = Ignore then
         return ;
      elsif Param_Tree = Nil then
         if Obj /= Nil then
            -- TODO: Instead, signal Kernel error
            raise Constraint_Error ;
         end if;
      elsif Param_Tree.all in Symbol_R then
         Bind (Env, Param_Tree, Obj) ;
      elsif Param_Tree.all in Pair_R then
         if Obj.all in Pair_R then
            Match_Bind (Env, Pair(Param_Tree).First, Pair(Obj).First) ;
            Match_Bind (Env, Pair(Param_Tree).Second, Pair(Obj).Second) ;
         else
            -- TODO: Instead, signal Kernel error
            raise Constraint_Error ;
         end if ;
      else
         -- TODO: Instead, signal Kernel error
         raise Constraint_Error ;
      end if ;
   end Match_Bind;

end Tarmi.Environments;
