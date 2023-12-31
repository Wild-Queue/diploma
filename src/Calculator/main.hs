-- File generated by the BNF Converter (bnfc 2.9.4.1).

-- | Program to test parser.

module Main where

import Prelude
  ( ($), (.)
  , Either(..)
  , Int, (>)
  , String, (++), concat, unlines
  , Show, show
  , IO, (>>), (>>=), mapM_, putStrLn
  , FilePath
  , getContents, readFile, Monad (return)
  )
import System.Environment ( getArgs )
import System.Exit        ( exitFailure )
import Control.Monad      ( when )

import LCalc.LambdaCalculus.Abs   ( Program(..) )
import LCalc.LambdaCalculus.Lex   ( Token, mkPosToken )
import LCalc.LambdaCalculus.Par   ( pProgram, myLexer )
import ToDeBruijn  ( toDeBruijn)
import Eval ( evalProgram )
import FromDeBruijn (fromDeBruijn)

import qualified LCalc.LambdaCalculus.Print as LCalculus
import qualified DBruijnCalc.DeBruijnGrammar.Print as DBCalculus

type Err        = Either String
type ParseFun a = [Token] -> Err a
type Verbosity  = Int

putStrV :: Verbosity -> String -> IO ()
putStrV v s = when (v > 1) $ putStrLn s

runFile :: Verbosity -> ParseFun Program -> FilePath -> IO ()
runFile v p f = putStrLn f >> readFile f >>= run "final" v p 

run :: String -> Verbosity -> ParseFun Program -> String -> IO ()
run flag v p s =
  case p ts of
    Left err -> do
      putStrLn "\nParse              Failed...\n"
      putStrV v "Tokens:"
      mapM_ (putStrV v . showPosToken . mkPosToken) ts
      putStrLn err
      exitFailure
    Right tree -> do
      putStrLn "\nParse Successful!\n"
      deBruijnEval v tree flag
  where
  ts = myLexer s
  showPosToken ((l,c),t) = concat [ show l, ":", show c, "\t", show t ]

deBruijnEval :: Int -> Program -> String -> IO ()
deBruijnEval v tree flag = do
  case tree of 
    AProgram programTree -> do
      -- showTreeLC v programTree
      let indexedTree = toDeBruijn tree
      case flag of 
        "db-pars" -> do
          putStrLn "De Bruijn indices:"
          showTreeDB v indexedTree
        _ -> return ()
      let simplifiedDB = evalProgram indexedTree
      case flag of 
        "db-eval" -> do
          putStrLn "De Bruijn indices after evaluated:"
          showTreeDB v simplifiedDB
        _ -> return ()
      let simplifiedLC = fromDeBruijn simplifiedDB
      case flag of 
        "final" -> do
          putStrLn "Evaluated expression in lambda-calculus notation:" 
          showTreeLC v simplifiedLC
        _ -> return ()
      

showTreeLC :: (Show a, LCalculus.Print a) => Int -> a -> IO ()
showTreeLC v tree = do
  putStrV v $ "\n[Abstract Syntax]\n\n" ++ show tree
  putStrV v $ "\n[Linearized tree]\n\n" ++ LCalculus.printTree tree

showTreeDB :: (Show a, DBCalculus.Print a) => Int -> a -> IO ()
showTreeDB v tree = do
  putStrV v $ "\n[Abstract Syntax]\n\n" ++ show tree
  putStrV v $ "\n[Linearized tree]\n\n" ++ DBCalculus.printTree tree

usage :: IO ()
usage = do
  putStrLn $ unlines
    [ "usage: Call with one of the following argument combinations:"
    , "  --help          Display this help message."
    , "  (no arguments)  Parse stdin verbosely."
    , "  (files)         Parse content of files verbosely."
    , "  -s (files)      Silent mode. Parse content of files silently."
    ]

main :: IO ()
main = do
  args <- getArgs
  case args of
    ["--help"] -> usage
    ["--final"]         -> getContents >>= run "final" 2 pProgram
    ["--db-pars"]      -> getContents >>= run "db-pars" 2 pProgram 
    ["--db-eval"]      -> getContents >>= run "db-eval" 2 pProgram 
    "-s":fs    -> mapM_ (runFile 0 pProgram) fs
    fs         -> mapM_ (runFile 2 pProgram) fs

