# Ethereum Proof-of-Stake Devnet with deployment of the SymbioticFi contracts

# Introduction

This repository is a fork of the [POS DevNet](https://github.com/ivy-net/eth-pos-devnet) repository, extended by an automatic deployment of the SymbioticFi contracts.
It is very similar to the [iv1](https://github.com/ivy-net/iv1), which is dedicated to the EigenLayer AVS's.

# Current state

## Scenarios
At the moment there is only an option to deploy smart contracts to the network.
It is located in the [symbioticfi](scenarios/symbioticfi/docker-compose.yml) scenario.


## Images
There is one packer script [symbioticfi-deployment](packer/symbioticfi-deployment.pkr.hcl).
