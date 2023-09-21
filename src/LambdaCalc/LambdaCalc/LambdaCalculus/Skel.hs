-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module LambdaCalc.LambdaCalculus.Skel where

import Prelude (($), Either(..), String, (++), Show, show)
import qualified LambdaCalc.LambdaCalculus.Abs

type Err = Either String
type Result = Err String

failure :: Show a => a -> Result
failure x = Left $ "Undefined case: " ++ show x

transIdent :: LambdaCalc.LambdaCalculus.Abs.Ident -> Result
transIdent x = case x of
  LambdaCalc.LambdaCalculus.Abs.Ident string -> failure x

transProgram :: LambdaCalc.LambdaCalculus.Abs.Program -> Result
transProgram x = case x of
  LambdaCalc.LambdaCalculus.Abs.AProgram term -> failure x

transTerm :: LambdaCalc.LambdaCalculus.Abs.Term -> Result
transTerm x = case x of
  LambdaCalc.LambdaCalculus.Abs.Var variable -> failure x
  LambdaCalc.LambdaCalculus.Abs.IntConst integer -> failure x
  LambdaCalc.LambdaCalculus.Abs.DoubleConst double -> failure x
  LambdaCalc.LambdaCalculus.Abs.Binder variable term -> failure x
  LambdaCalc.LambdaCalculus.Abs.Application term1 term2 -> failure x
  LambdaCalc.LambdaCalculus.Abs.Plus term1 term2 -> failure x
  LambdaCalc.LambdaCalculus.Abs.Minus term1 term2 -> failure x

transVariable :: LambdaCalc.LambdaCalculus.Abs.Variable -> Result
transVariable x = case x of
  LambdaCalc.LambdaCalculus.Abs.Identifier ident -> failure x
  LambdaCalc.LambdaCalculus.Abs.Bound integer -> failure x
