-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module ShiftFunction where

import Prelude (($), String, (++), (>), (>=), Show, show, Integer, Maybe (..), fst, snd, otherwise, (==), (+))
import qualified DBruijnCalc.DeBruijnGrammar.Abs
import DBruijnCalc.DeBruijnGrammar.Abs ( Program(..), Term(..), Ident(..), Variable(..) )


shiftIdent :: Ident -> Ident
shiftIdent x = case x of
  Ident string -> Ident string

shiftTerm :: Term -> Integer -> Integer -> Term
shiftTerm x cutoff d = case x of
  Var variable -> Var (shiftVariable variable cutoff d) 
  IntConst integer -> IntConst integer
  DoubleConst double -> DoubleConst double
  Binder term -> 
    Binder (shiftTerm term (cutoff+1) d)
  LetBinder term1 term2 -> 
    LetBinder (shiftTerm term1 cutoff d) (shiftTerm term2 (cutoff+1) d)
  Application term1 term2 ->
    Application (shiftTerm term1 cutoff d) (shiftTerm term2 cutoff d)
  Plus term1 term2 -> 
    Plus (shiftTerm term1 cutoff d) (shiftTerm term2 cutoff d)
  Minus term1 term2 ->
    Minus (shiftTerm term1 cutoff d) (shiftTerm term2 cutoff d)
    
shiftVariable :: Variable -> Integer -> Integer -> Variable
shiftVariable x cutoff d = case x of
  Identifier ident -> Identifier (shiftIdent ident)
  Bound integer -> 
    if integer >= cutoff
      then Bound (integer + d)
      else Bound integer
