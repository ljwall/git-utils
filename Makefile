build:
	ghcup run --ghc 9.2.8 --cabal 3.14.2.0 cabal build
.PHONY: build

install:
	ghcup run --ghc 9.2.8 --cabal 3.14.2.0 -- cabal install --overwrite-policy=always
.PHONY: install
