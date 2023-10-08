-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module ToDeBruĳn where

import Prelude (($), Either(..), String, (++), Show, show, Integer, Maybe (..), fst, snd, otherwise, (==), (+), map)
import qualified LCalc.LambdaCalculus.Abs as LCalculus
import qualified DBruijnCalc.DeBruijnGrammar.Abs as DBCalculus

upShiftDict :: [(String, Integer)] -> [(String, Integer)]
upShiftDict = map (\ x -> (fst x, snd x + 1))

returnIndex :: [(String, Integer)] -> String -> Maybe Integer
returnIndex [] value = Nothing
returnIndex (x:xs) value
    | fst x == value = Just (snd x)
    | otherwise = returnIndex xs value


addIndx :: [(String, Integer)] -> String -> [(String, Integer)]
addIndx [] value = [(value, 0)]
addIndx (x:xs) value 
  | fst x == value = (fst x, 0) : xs
  | otherwise = x : addIndx xs value


toDeBruĳnIdent :: LCalculus.Ident -> DBCalculus.Ident
toDeBruĳnIdent x = case x of
  LCalculus.Ident string -> DBCalculus.Ident string

toDeBruĳn :: LCalculus.Program -> DBCalculus.Program
toDeBruĳn prog = case prog of
    LCalculus.AProgram terms -> DBCalculus.AProgram (map (\ x -> toDeBruĳnTerm x []) terms)

toDeBruĳnTerm :: LCalculus.Term -> [(String, Integer)] -> DBCalculus.Term
toDeBruĳnTerm x nameDict = case x of
  LCalculus.Var variable -> DBCalculus.Var (toDeBruĳnVariable variable nameDict) 
  LCalculus.IntConst integer -> DBCalculus.IntConst integer
  LCalculus.DoubleConst double -> DBCalculus.DoubleConst double
  LCalculus.Binder variable term -> do 
    case variable of 
      LCalculus.Identifier (LCalculus.Ident varName) -> do
        let dictTermScope = upShiftDict nameDict
        let dictWithVar = addIndx dictTermScope varName
        let indexedTerm = toDeBruĳnTerm term dictWithVar 
        DBCalculus.Binder indexedTerm
  
  LCalculus.LetBinder variable term1 term2 -> do 
    case variable of 
      LCalculus.Identifier (LCalculus.Ident varName) -> do
        let dictTermScope = upShiftDict nameDict
        let dictWithVar = addIndx dictTermScope varName

        let dbTerm1 = toDeBruĳnTerm term1 nameDict -- Для первого терма не создается новый scope так как variable там не применяется
        let dbTerm2 = toDeBruĳnTerm term2 dictWithVar
        
        DBCalculus.LetBinder dbTerm1 dbTerm2 
    
  LCalculus.Application term1 term2 -> do 
    let updatedTerm1 = toDeBruĳnTerm term1 nameDict 
    let updatedTerm2 = toDeBruĳnTerm term2 nameDict 
    DBCalculus.Application updatedTerm1 updatedTerm2

  LCalculus.Plus term1 term2 -> do 
    let updatedTerm1 = toDeBruĳnTerm term1 nameDict 
    let updatedTerm2 = toDeBruĳnTerm term2 nameDict
    DBCalculus.Plus updatedTerm1 updatedTerm2

  LCalculus.Minus term1 term2 ->  do 
    let updatedTerm1 = toDeBruĳnTerm term1 nameDict
    let updatedTerm2 = toDeBruĳnTerm term2 nameDict
    DBCalculus.Minus updatedTerm1 updatedTerm2

toDeBruĳnVariable :: LCalculus.Variable -> [(String, Integer)] -> DBCalculus.Variable
toDeBruĳnVariable x nameDict = case x of
  LCalculus.Identifier ident -> 
    case toDeBruĳnIdent ident of
      DBCalculus.Ident string -> 
        case returnIndex nameDict string of 
          Nothing -> DBCalculus.Identifier (toDeBruĳnIdent ident)
          Just index -> DBCalculus.Bound index