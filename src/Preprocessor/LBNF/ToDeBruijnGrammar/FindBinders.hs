-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module LBNF.ToDeBruijnGrammar.FindBinders where

import Prelude (($), Either(..), String, (++), Show, show, map, Maybe, reverse)
import qualified LBNF.LBNF.Abs
import LBNF.LBNF.Abs ( Ident(..), Grammar(..), Def(..), Item(..), Cat(..) )
import LBNF.LBNF.Abs ( Label(..), LabelId(..), Reg(..), MinimumSize(..) )
import LBNF.LBNF.Abs ( RHS(..), VariableType(..), ProfItem(..), IntList(..) )

findBindersGrammar :: Grammar -> [String] -> [String]
findBindersGrammar x deleteList = case x of
  LBNF.LBNF.Abs.MkGrammar defs -> reverse (findBindersDefs defs deleteList)

findBindersDefs :: [Def] -> [String] -> [String]
findBindersDefs [x] deleteList = findBindersDef x deleteList
findBindersDefs (x:xs) deleteList = findBindersDefs xs (findBindersDef x deleteList)

findBindersDef :: Def -> [String] -> [String]
findBindersDef x deleteList = case x of
  LBNF.LBNF.Abs.Variable variabletype cat ->          -- With Variable affect
        case variabletype of 
            VarScope -> deleteList
            VarName -> deleteList
            VarBinder -> case bindTransCat cat of
                            Ident string -> string:deleteList
  _ -> deleteList   -- With Variable affect

bindTransCat :: Cat -> Ident
bindTransCat x = case x of
  LBNF.LBNF.Abs.ListCat cat -> bindTransCat cat     -- With Variable affect
  LBNF.LBNF.Abs.IdCat ident -> ident                -- With Variable affect