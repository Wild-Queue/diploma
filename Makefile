build: LambdaCalculus.cf
	mkdir -p src/LambdaCalc/
	cd src/LambdaCalc/ && (bnfc -m -d --haskell ../../LambdaCalculus.cf -p LambdaCalc;  cd ../../)
	cd src/LambdaCalc/ && (make; cd ../../)

test: ./src/LambdaCalc/LambdaCalc/LambdaCalculus/Test
	./src/LambdaCalc/LambdaCalc/LambdaCalculus/Test

./src/LambdaCalc/LambdaCalc/main : build
	ghc ./src/LambdaCalc/LambdaCalc/LambdaCalculus/Abs.hs ./src/LambdaCalc/LambdaCalc/LambdaCalculus/Lex.hs ./src/LambdaCalc/LambdaCalc/LambdaCalculus/Par.hs ./src/LambdaCalc/LambdaCalc/LambdaCalculus/Print.hs ./src/LambdaCalc/LambdaCalc/ShiftFunction.hs ./src/LambdaCalc/LambdaCalc/Analyser.hs ./src/LambdaCalc/LambdaCalc/Substitute.hs ./src/LambdaCalc/LambdaCalc/main.hs


run: ./src/LambdaCalc/LambdaCalc/main
	./src/LambdaCalc/LambdaCalc/main

clean:
	cd src/LambdaCalc/ && (make clean; cd ../../)

clean-bak:
	cd src/LambdaCalc/ && (rm -f *.bak; cd ../../)
