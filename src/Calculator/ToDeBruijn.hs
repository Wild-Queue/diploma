-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module ToDeBruijn where

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


toDeBruijnIdent :: LCalculus.Ident -> DBCalculus.Ident
toDeBruijnIdent x = case x of
  LCalculus.Ident string -> DBCalculus.Ident string

toDeBruijn :: LCalculus.Program -> DBCalculus.Program
toDeBruijn prog = case prog of
    LCalculus.AProgram terms -> DBCalculus.AProgram (map (\ x -> toDeBruijnTerm x []) terms)

toDeBruijnTerm :: LCalculus.Term -> [(String, Integer)] -> DBCalculus.Term
toDeBruijnTerm x nameDict = case x of
  LCalculus.Var variable -> DBCalculus.Var (toDeBruijnVariable variable nameDict) 
  LCalculus.Lam variable term -> do 
    case variable of 
      LCalculus.PatternVar (LCalculus.VarIdent (LCalculus.Ident varName)) -> 
        case term of 
          LCalculus.ScopedTerm term -> do
            let dictTermScope = upShiftDict nameDict
            let dictWithVar = addIndx dictTermScope varName
            let indexedTerm = toDeBruijnTerm term dictWithVar 
            DBCalculus.Lam (DBCalculus.ScopedTerm indexedTerm)
  
  LCalculus.Let variable term1 term2 -> do 
    case variable of 
      LCalculus.PatternVar (LCalculus.VarIdent (LCalculus.Ident varName)) ->
        case term2 of 
          LCalculus.ScopedTerm term2 -> do
            let dictTermScope = upShiftDict nameDict
            let dictWithVar = addIndx dictTermScope varName

            let dbTerm1 = toDeBruijnTerm term1 nameDict -- Для первого терма не создается новый scope так как variable там не применяется
            let dbTerm2 = toDeBruijnTerm term2 dictWithVar
            
            DBCalculus.Let dbTerm1 (DBCalculus.ScopedTerm dbTerm2) 
    
  LCalculus.Application term1 term2 -> do 
    let updatedTerm1 = toDeBruijnTerm term1 nameDict 
    let updatedTerm2 = toDeBruijnTerm term2 nameDict 
    DBCalculus.Application updatedTerm1 updatedTerm2

toDeBruijnVariable :: LCalculus.VarIdent -> [(String, Integer)] -> DBCalculus.VarIdent
toDeBruijnVariable x nameDict = case x of
  LCalculus.VarIdent ident -> 
    case toDeBruijnIdent ident of
      DBCalculus.Ident string -> 
        case returnIndex nameDict string of 
          Nothing -> DBCalculus.VarIdent (toDeBruijnIdent ident)
          Just index -> DBCalculus.DBBound index