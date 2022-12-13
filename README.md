# Formal Verification, the Move Language, and the Move Prover
This repository contains the source code for the examples in CertiK's 
blog about the Move Prover.
For a technical deep dive into deductive verification with Move,
please visit our [blog](https://certik.com/resources/blog/2wSOZ3mC55AB6CYol6Q2rP-formal-verification-the-move-language-and-the-move-prover)!

## Requirements
All the example projects in this repository have been tested with
the Move command line interface in version 0.1.0.
To install it, please follow the instructions [here](https://github.com/move-language/move/blob/main/language/move-prover/doc/user/install.md).

## Running the examples
Each of the examples is hosted in a sub-directory of this repository.
To build an example, just enter the corresponding folder and run
```bash
$> move build
```
That should build the project. Some projects (e.g. the `coin` example) have
a dedicated README that explains some scripts and interactions that you may want to experiment with.

To run the Move Prover, just execute
```bash
$> move prove
```
That should run the prover on the entire project. 
For some of the projects (e.g. `bubble_sort`), some proofs will (intentionally) fail. That is due to missing invariants and specification helpers. For detailed explanations, please follow our [blog](https://certik.com/resources/blog/2wSOZ3mC55AB6CYol6Q2rP-formal-verification-the-move-language-and-the-move-prover).

If you want to restrict the Move Prover's scope to a single source file, you may run
```bash
$> move prove --target <MODULE_NAME>
```
For example, to only verify the example module `bubble_sorts_abort` that showcases the `aborts_if` condition, run the Move Prover within the `bubble_sort` folder as follows:
```bash
$> move prove --target "bubble_sort_aborts"
```
