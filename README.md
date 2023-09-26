# Spellcrafters of the Realm

Spellcrafter (working title) is both a physical card game and an on-chain game set in the Realms Autonomous World.

## Prerequisites

This repo uses [just](https://github.com/casey/just) for running commands. It is like a modern version of Make.

## Running locally

### Requirements
    - Installed [bun](https://bun.sh/)
    - Installed [Dojo tooling](https://www.dojoengine.org/en/)

### Steps

First build the contracts

```shell
just build_contracts
```

It is best to run 3 separate shells to run the game locally. Run each of the below commands in a new terminal

- Katana local devnet:  
```shell
just start_devnet
```

- Migrate contracts and start indexer:  
```shell
just start_indexer
```

- Client webserver  
```shell
just start_client
```

If everything ran correctly this should open your browser with the game ready to play!

## Generating cards images

If you want to play test the physical version you can produce all the cards from the `cards.csv` table.

Requires:
- python3
- just 

Run the command

```shell
just cardgen
```

This will dump the images in `cards-output`.

Follow this guide to print them at the desired size https://www.wikihow.com/Print-Multiple-Images-on-One-Page-on-PC-or-Mac

## Updating generated code

The code in the `contracts/properties` directory is generated from the `cards.csv`. If you make any changes to cards stats you can regenerate these using

```shell
just codegen
```