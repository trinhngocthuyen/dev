install.dev:
	(which pre-commit &> /dev/null) || python3 -m pip install -U pre-commit
	pre-commit install

install:
	python3 install.py

format:
	pre-commit run --all-files
