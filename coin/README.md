# Coin example
This Move project implements a simple token contract. It's main purpose is to showcase formal verification of Move source code using the Move Prover.

## References
The latest reference for the Move language can be found here.
The latest reference for the Move Specification Language (MSL) is here.

## Getting started
To build the project, install Move and the Move Prover.
The project can be built using
```
coin$ move build
```
After that, one can experiment a bit in a sandbox. To initialize (or sweep) it, do
```
coin$ move sandbox clean
```
The compiled contract can be deployed using
```
coin$ move sandbox publish --ignore-breaking-changes
```
Publishing (or re-publishing) is necessary whenever the project has been built in order to make sure that the sandbox is using the latest version.

The project contains two scripts that can be used to initialize the contract (and to take ownership), as well as to distribute some tokens:
```
coin$ move sandbox run scripts/deploy.move --args 0x02 100
```
This will move a resource that holds the contract's state to the contract address. That address is passed as argument (`0x02` in our case). The contract is initialized to cap the total supply at 100 coins (i.e. the second argument).

Tokens can be distributed by the `airdrop` script, which takes three arguments: The first is the address `0x02` of the token, the second argument represents the number of tokens to mint, and the third address denotes the recipient.
```
coin$ move sandbox run scripts/airdrop.move --args 0x02 30 0x06
```
The above command mints `30` coins, adds a `Coin` resource to address `0x06` and transfers the coins there. It will fail if the destination address already has a `Coin` resource or if the total amount of circulating tokens exceeds the (hard-coded) limit of `100`.

Note: Debug output is limited in Move - and entirely disabled in this project, as I ran into conflicts with debug outputs and the Move Prover.
