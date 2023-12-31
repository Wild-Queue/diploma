-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- Templates for pattern matching on abstract syntax

{-# OPTIONS_GHC -fno-warn-unused-matches #-}

module LBNF.ToDeBruijnGrammar.ProcessVariableBinderRule where

import Prelude (($), Either(..), String, (++), (==), Show, show, map, Maybe (Nothing, Just), reverse, Bool (True), otherwise, Foldable (foldl), and)
import qualified LBNF.LBNF.Abs
import LBNF.LBNF.Abs ( Ident(..), Grammar(..), Def(..), Item(..), Cat(..) )
import LBNF.LBNF.Abs ( Label(..), LabelId(..), Reg(..), MinimumSize(..) )
import LBNF.LBNF.Abs ( RHS(..), VariableType(..), ProfItem(..), IntList(..) )

findInDeleteList :: [String] -> String -> Bool
findInDeleteList [x] label = x == label
findInDeleteList (x:xs) label 
  | x == label = True
  | otherwise = findInDeleteList xs label

transIdent :: Ident -> [String] -> Maybe Ident
transIdent x deleteList = case x of
  LBNF.LBNF.Abs.Ident string -> (if findInDeleteList deleteList string 
                                  then Nothing
                                  else Just (Ident string) )

processGrammar :: Grammar -> [String] -> Grammar
processGrammar x deleteList = case x of
  LBNF.LBNF.Abs.MkGrammar defs -> MkGrammar (processDefs defs deleteList)

processDefs :: [Def] -> [String] -> [Def]
processDefs [def] deleteList = case processDef def deleteList of 
    Nothing -> []
    Just newDef -> [newDef]
processDefs (def:defs) deleteList = case processDef def deleteList of 
  Nothing -> processDefs defs deleteList
  Just def -> def:processDefs defs deleteList

processDef :: Def -> [String] -> Maybe Def
processDef x deleteList = case x of
  LBNF.LBNF.Abs.Rule label cat items -> case transCat cat deleteList of 
          Nothing -> Nothing
          Just cat -> Just (Rule label cat (transItems items deleteList))   -- With Variable affect
  LBNF.LBNF.Abs.Comment string -> Just (Comment string)
  LBNF.LBNF.Abs.Comments string1 string2 -> Just (Comments string1 string2)
  LBNF.LBNF.Abs.Internal label cat items -> case transCat cat deleteList of   -- With Variable affect
          Nothing -> Nothing
          Just cat -> Just (Internal label cat (transItems items deleteList))   
  LBNF.LBNF.Abs.Token ident reg -> case transIdent ident deleteList of        -- With Variable affect
                                      Nothing -> Nothing
                                      Just _ -> Just (Token ident reg)            
  LBNF.LBNF.Abs.PosToken ident reg -> case transIdent ident deleteList of     -- With Variable affect
                                        Nothing -> Nothing
                                        Just _ -> Just (PosToken ident reg)         
  LBNF.LBNF.Abs.Entryp idents -> Just (Entryp (transIdens idents deleteList))              -- With Variable affect
  LBNF.LBNF.Abs.Separator minimumsize cat string -> Just (Separator minimumsize cat string)   -- With Variable affect
  LBNF.LBNF.Abs.Terminator minimumsize cat string -> Just (Terminator minimumsize cat string)  -- With Variable affect
  LBNF.LBNF.Abs.Coercions ident integer -> case transIdent ident deleteList of    -- With Variable affect
                                      Nothing -> Nothing
                                      Just _ -> Just (Coercions ident integer)     
  LBNF.LBNF.Abs.Rules ident rhss -> case transIdent ident deleteList of 
                                      Nothing -> Nothing
                                      Just _ -> Just (Rules ident (map (`transRHS` deleteList) rhss ))                   -- With Variable affect
  LBNF.LBNF.Abs.Variable variabletype cat ->          -- With Variable affect
        case variabletype of 
            VarScope -> Just (Variable variabletype cat)
            VarName -> Just (Variable variabletype cat)
            VarBinder -> Nothing
  LBNF.LBNF.Abs.Layout strings -> Just (Layout strings)
  LBNF.LBNF.Abs.LayoutStop strings -> Just (LayoutStop strings)
  LBNF.LBNF.Abs.LayoutTop -> Just LayoutTop

transIdens :: [Ident] -> [String] -> [Ident]
transIdens [] deleteList = []
transIdens (ident:idents) deleteList = case transIdent ident deleteList of 
          Nothing -> transIdens idents deleteList
          Just ident -> ident:transIdens idents deleteList

transItem :: Item -> [String] -> Maybe Item
transItem x deleteList = case x of
  LBNF.LBNF.Abs.Terminal string -> Just(Terminal string)
  LBNF.LBNF.Abs.NTerminal cat -> case transCat cat deleteList of 
            Nothing -> Nothing
            Just ident -> Just(NTerminal cat)      -- With Variable affect

transCat :: Cat -> [String] -> Maybe Cat
transCat x deleteList = case x of
  LBNF.LBNF.Abs.ListCat cat -> case transCat cat deleteList of 
            Nothing -> Nothing
            Just ident -> Just(ListCat cat)    -- With Variable affect
  LBNF.LBNF.Abs.IdCat ident -> case transIdent ident deleteList of 
            Nothing -> Nothing
            Just ident -> Just(IdCat ident)  -- With Variable affect

transLabel :: Label -> Label
transLabel x = case x of
  LBNF.LBNF.Abs.LabNoP labelid -> LabNoP labelid
  LBNF.LBNF.Abs.LabP labelid profitems -> LabP labelid profitems
  LBNF.LBNF.Abs.LabPF labelid1 labelid2 profitems -> LabPF labelid1 labelid2 profitems
  LBNF.LBNF.Abs.LabF labelid1 labelid2 -> LabF labelid1 labelid2

transLabelId :: LabelId -> LabelId
transLabelId x = case x of
  LBNF.LBNF.Abs.Id ident -> Id ident
  LBNF.LBNF.Abs.Wild -> Wild
  LBNF.LBNF.Abs.ListE -> ListE
  LBNF.LBNF.Abs.ListCons -> ListCons
  LBNF.LBNF.Abs.ListOne -> ListOne

transProfItem :: ProfItem -> ProfItem
transProfItem x = case x of
  LBNF.LBNF.Abs.ProfIt intlists integers -> ProfIt intlists integers

transIntList :: IntList -> IntList
transIntList x = case x of
  LBNF.LBNF.Abs.Ints integers -> Ints integers

transVariableType :: VariableType -> VariableType
transVariableType x = case x of
  LBNF.LBNF.Abs.VarScope -> VarScope   -- Part of Variable
  LBNF.LBNF.Abs.VarName -> VarName    -- Part of Variable
  LBNF.LBNF.Abs.VarBinder -> VarBinder  -- Part of Variable

transRHS :: RHS -> [String] -> RHS
transRHS x deleteList = case x of
  LBNF.LBNF.Abs.MkRHS items -> MkRHS (transItems items deleteList)  -- With Variable affect

transItems :: [Item] -> [String] -> [Item]
transItems [] deleteList = []
transItems (item:items) deleteList = case transItem item deleteList of 
        Nothing -> transItems items deleteList
        Just item -> item:transItems items deleteList

transMinimumSize :: MinimumSize -> MinimumSize
transMinimumSize x = case x of
  LBNF.LBNF.Abs.MNonempty -> MNonempty
  LBNF.LBNF.Abs.MEmpty -> MEmpty

transReg :: Reg -> Reg
transReg x = case x of
  LBNF.LBNF.Abs.RSeq reg1 reg2 -> RSeq reg1 reg2
  LBNF.LBNF.Abs.RAlt reg1 reg2 -> RAlt reg1 reg2
  LBNF.LBNF.Abs.RMinus reg1 reg2 -> RMinus reg1 reg2
  LBNF.LBNF.Abs.RStar reg -> RStar reg
  LBNF.LBNF.Abs.RPlus reg -> RPlus reg
  LBNF.LBNF.Abs.ROpt reg -> ROpt reg
  LBNF.LBNF.Abs.REps -> REps
  LBNF.LBNF.Abs.RChar char -> RChar char
  LBNF.LBNF.Abs.RAlts string -> RAlts string
  LBNF.LBNF.Abs.RSeqs string -> RSeqs string
  LBNF.LBNF.Abs.RDigit -> RDigit
  LBNF.LBNF.Abs.RLetter -> RLetter
  LBNF.LBNF.Abs.RUpper -> RUpper
  LBNF.LBNF.Abs.RLower -> RLower
  LBNF.LBNF.Abs.RAny -> RAny