ast:
	clang -Xclang -ast-dump=json -fsyntax-only example.c > clang_ast_output.json
run:
	python3 example.py
