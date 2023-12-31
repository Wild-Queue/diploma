-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module Eval where

import Prelude (($), Either(..), String, (++), Show, show, (+), map)
import qualified DBruijnCalc.DeBruijnGrammar.Abs
import DBruijnCalc.DeBruijnGrammar.Abs ( Program(..), Term(..), Ident(..), VarIdent(..), ScopedTerm(..) )
import Substitute ( substTerm )
import ShiftFunction ( shiftTerm )


evalIdent :: Ident -> Ident
evalIdent x = case x of
  Ident string -> Ident string

evalProgram :: Program -> Program
evalProgram x = case x of
  AProgram terms -> AProgram (map (\ x -> evalTerm x) terms)

evalTerm :: Term -> Term
evalTerm x = case x of
  Var variable -> Var (evalVariable variable)
  Lam term -> 
    case term of 
      ScopedTerm term -> Lam (ScopedTerm (evalTerm term))
  Let term1 term2 -> 
    case term2 of 
      ScopedTerm term2 -> do 
        let newTerm1 = evalTerm term1
        let newTerm2 = evalTerm term2
        let beforeDownShift = substTerm newTerm2 0 newTerm1
        shiftTerm beforeDownShift 1 (-1)
    
  Application term1 term2 -> do
    let newTerm1 = evalTerm term1
    let newTerm2 = evalTerm term2
    case newTerm1 of 
      Lam (ScopedTerm binderTerm) -> do 
        let beforeDownShift = substTerm binderTerm 0 newTerm2
        shiftTerm beforeDownShift 1 (-1)
      _ -> Application newTerm1 newTerm2
    

evalVariable :: VarIdent -> VarIdent
evalVariable x = case x of
  VarIdent ident -> VarIdent ident
  DBBound integer -> DBBound integer
