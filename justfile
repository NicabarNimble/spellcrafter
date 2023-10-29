set positional-arguments

default:
  just --list

cardgen:
	sh ./scripts/gen-cards.sh

codegen:
	sh ./scripts/gen-code.sh

build_contracts:
	cd contracts && sozo build

test:
	cd contracts && sozo test

migrate:
	cd contracts && sozo migrate

# fetch the cards from the google sheet and write to cards.csv in this repo
fetch_cards:
	wget "https://docs.google.com/spreadsheets/d/1sGTB4XvrHmZ_Dn9QZinwOZWRTMmCjCy_FNpdIodMlHE/gviz/tq?tqx=out:csv&sheet=cards" -O cards.csv

# Set the auth for the world contract so spellcrafter systems can interact with the required components
set_auth:
	#!/usr/bin/env bash
	set -euxo pipefail

	WORLD_ADDRESS=$(just migrate | grep "at address" | grep -oE '(0x[a-fA-F0-9]{63})')
	cd contracts
	sozo auth writer --world ${WORLD_ADDRESS} ValueInGame 0x50f40f8d1037bc5de506631e130ddad60d82c8436896af4a9dcf00f3dc02a55
	sozo auth writer --world ${WORLD_ADDRESS} Owner 0x7e2c27d4a3345ec003984c76554082063e62d99c971fc0b1d754bfdce30b853 
	sozo auth writer --world ${WORLD_ADDRESS} Occupied 0x7e683bda2adbf53198e0af9437f58354f6078fd6e311f42b05cec18639e963c 

# start the dev server hosting the web client
start_client:
	cd client && bun install && bun run dev

# start a katana devnet
start_devnet:
	katana --seed=0

# migrates, authorizes, then start the indexer. Requires a devnet running on localhost:5050
start_indexer:
	#!/usr/bin/env bash
	set -euxo pipefail
	just build_contracts
	WORLD_ADDRESS=$(just migrate | grep "at address" | grep -oE '(0x[a-fA-F0-9]{63})')
	just set_auth
	cd contracts && torii --world ${WORLD_ADDRESS}
