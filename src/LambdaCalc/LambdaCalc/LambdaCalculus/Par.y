-- -*- haskell -*- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Parser definition for use with Happy
{
{-# OPTIONS_GHC -fno-warn-incomplete-patterns -fno-warn-overlapping-patterns #-}
{-# LANGUAGE PatternSynonyms #-}

module LambdaCalc.LambdaCalculus.Par
  ( happyError
  , myLexer
  , pProgram
  , pTerm
  , pVariable
  ) where

import Prelude

import qualified LambdaCalc.LambdaCalculus.Abs
import LambdaCalc.LambdaCalculus.Lex

}

%name pProgram Program
%name pTerm Term
%name pVariable Variable
-- no lexer declaration
%monad { Err } { (>>=) } { return }
%tokentype {Token}
%token
  '('      { PT _ (TS _ 1) }
  ')'      { PT _ (TS _ 2) }
  '+'      { PT _ (TS _ 3) }
  '-'      { PT _ (TS _ 4) }
  '.'      { PT _ (TS _ 5) }
  'lambda' { PT _ (TS _ 6) }
  L_Ident  { PT _ (TV $$)  }
  L_doubl  { PT _ (TD $$)  }
  L_integ  { PT _ (TI $$)  }

%%

Ident :: { LambdaCalc.LambdaCalculus.Abs.Ident }
Ident  : L_Ident { LambdaCalc.LambdaCalculus.Abs.Ident $1 }

Double  :: { Double }
Double   : L_doubl  { (read $1) :: Double }

Integer :: { Integer }
Integer  : L_integ  { (read $1) :: Integer }

Program :: { LambdaCalc.LambdaCalculus.Abs.Program }
Program : Term { LambdaCalc.LambdaCalculus.Abs.AProgram $1 }

Term :: { LambdaCalc.LambdaCalculus.Abs.Term }
Term
  : Variable { LambdaCalc.LambdaCalculus.Abs.Var $1 }
  | Integer { LambdaCalc.LambdaCalculus.Abs.IntConst $1 }
  | Double { LambdaCalc.LambdaCalculus.Abs.DoubleConst $1 }
  | 'lambda' Variable '.' Term { LambdaCalc.LambdaCalculus.Abs.Binder $2 $4 }
  | '(' Term Term ')' { LambdaCalc.LambdaCalculus.Abs.Application $2 $3 }
  | Term '+' Term { LambdaCalc.LambdaCalculus.Abs.Plus $1 $3 }
  | Term '-' Term { LambdaCalc.LambdaCalculus.Abs.Minus $1 $3 }
  | '(' Term ')' { $2 }

Variable :: { LambdaCalc.LambdaCalculus.Abs.Variable }
Variable : Ident { LambdaCalc.LambdaCalculus.Abs.Identifier $1 }

{

type Err = Either String

happyError :: [Token] -> Err a
happyError ts = Left $
  "syntax error at " ++ tokenPos ts ++
  case ts of
    []      -> []
    [Err _] -> " due to lexer error"
    t:_     -> " before `" ++ (prToken t) ++ "'"

myLexer :: String -> [Token]
myLexer = tokens

}

