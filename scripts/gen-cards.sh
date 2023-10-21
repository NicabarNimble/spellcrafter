#!/usr/bin/env bash
set -e

python3 -m venv env
source env/bin/activate
pip install -r ./card-gen/requirements.txt

python3 ./card-gen/src/run_gen.py --gen_config ./gen_config.json --deck_config ./deck_config.json --decklist ./cards.csv

deactivate
