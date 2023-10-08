build: ./Grammars/LambdaCalculus.cf ./Grammars/DeBruijnGrammar.cf
	mkdir -p src/Calculator/
	cd src/Calculator/ && (bnfc -m -d --haskell ../../Grammars/DeBruijnGrammar.cf -p DBruijnCalc ; make; cd ../../)
	cd src/Calculator/ && (bnfc -m -d --haskell ../../Grammars/LambdaCalculus.cf -p LCalc ; make; cd ../../)

test: ./src/Calculator/LCalc/LambdaCalculus/Test
	./src/Calculator/LCalc/LambdaCalculus/Test


./src/Calculator/main : build 
	ghc ./src/Calculator/LCalc/LambdaCalculus/Abs.hs ./src/Calculator/LCalc/LambdaCalculus/Lex.hs ./src/Calculator/LCalc/LambdaCalculus/Par.hs ./src/Calculator/LCalc/LambdaCalculus/Print.hs ./src/Calculator/DBruijnCalc/DeBruijnGrammar/Abs.hs ./src/Calculator/DBruijnCalc/DeBruijnGrammar/Lex.hs ./src/Calculator/DBruijnCalc/DeBruijnGrammar/Par.hs ./src/Calculator/DBruijnCalc/DeBruijnGrammar/Print.hs ./src/Calculator/*.hs

run: ./src/Calculator/main
	./src/Calculator/main

clean:
	cd src/Calculator/LCalc/ && (make clean; cd ../../)
	-rm -f src/Calculator/*.hi src/Calculator/*.o src/Calculator/*.bak

clean-bak:
	cd src/Calculator/LCalc/ && (rm -f *.bak; cd ../../../)
