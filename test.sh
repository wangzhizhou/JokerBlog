#!/usr/bin/env bash

pip install -U virtualenv
python -mvirtualenv --system-site-packages --no-download vblogenv
python vblogenv/bin/pip install --use-wheel -U  Pygments setuptools docutils mock pillow alabaster commonmark recommonmark mkdocs
python vblogenv/bin/pip install -r requirements.txt
python vblogenv/bin/mkdocs build --clean 
python vblogenv/bin/mkdocs serve -a 0.0.0.0:8000 
