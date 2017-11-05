#!/usr/bin/env bash

pip install virtualenv
virtualenv vblogenv
source vblogenv/bin/activate
pip install --use-wheel -U  Pygments setuptools docutils mock pillow alabaster commonmark recommonmark mkdocs
pip install -r requirements.txt
mkdocs build --clean 
mkdocs serve -a 0.0.0.0:8000