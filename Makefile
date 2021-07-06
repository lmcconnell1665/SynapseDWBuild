setup:
	python3 -m venv ~/.synapsedwbuild

install:
	pip install --upgrade pip &&\
		pip install -r requirements.txt