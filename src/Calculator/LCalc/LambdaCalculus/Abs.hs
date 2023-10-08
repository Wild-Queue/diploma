-- File generated by the BNF Converter (bnfc 2.9.4.1).

{-# LANGUAGE GeneralizedNewtypeDeriving #-}

-- | The abstract syntax of language LambdaCalculus.

module LCalc.LambdaCalculus.Abs where

import Prelude (Double, Integer, String)
import qualified Prelude as C (Eq, Ord, Show, Read)
import qualified Data.String

data Program = AProgram [Term]
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Term
    = Var Variable
    | IntConst Integer
    | DoubleConst Double
    | Binder Variable Term
    | LetBinder Variable Term Term
    | Application Term Term
    | Plus Term Term
    | Minus Term Term
  deriving (C.Eq, C.Ord, C.Show, C.Read)

data Variable = Identifier Ident
  deriving (C.Eq, C.Ord, C.Show, C.Read)

newtype Ident = Ident String
  deriving (C.Eq, C.Ord, C.Show, C.Read, Data.String.IsString)

