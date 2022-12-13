address CoinModule {

    // The coin_manager handles operations like minting, burning, and transferring coins.
    // It keeps track of the total amount of coins that are circulating and returns that
    // information via its total_circulating function.
    module coin_manager {
        use std::signer;
        use CoinModule::coin;
        use CoinModule::coin::Coin;

        // Some error codes that we use to explain when a transaction reverts.
        const ERROR_REQUIRES_OWNER: u64 = 0x1;
        const ERROR_LIMIT_EXCEEDED: u64 = 0x2;
        const ERROR_NO_RESOURCE: u64 = 0x3;

        // The state of the contract. This resource is only attached to the
        // address where the contract is deployed to. It is used to keep track
        // of the number of circulating coins and allows to specify an upper
        // limit on the supply.
        struct ContractState has key, store { circulating: u64
                                            , max_supply: u64
                                            }

        // Initialize the module and set the admissible maximum supply.
        // This function requires the signature of the owner of the address
        // where the module gets deployed to.
        public fun init(account: signer, max_supply: u64) {
            assert!(signer::address_of(&account) == @CoinModule, ERROR_REQUIRES_OWNER);
            let state = ContractState { circulating: 0
                                      , max_supply };
            move_to<ContractState>(&account, state);
        }

        // Determine if the supplied address has a Coin resource attached to it.
        public fun has_resource(account: address): bool {
            coin::has_resource(account)
        }

        // Adds a Coin resource with value zero to the signer.
        // Only then may the signer receive or send Coins.
        public fun add_resource(account: &signer) {
            coin::add_resource(account)
        }

        // Create a Coin with the number of coins specified in amount. This is a
        // priviledged operation; it can only be executed if the account parameter
        // holds the signature of the contract owner.
        public fun mint(account: signer, amount: u64): Coin acquires ContractState {
            assert!(signer::address_of(&account) == @CoinModule, ERROR_REQUIRES_OWNER);

            let state = borrow_global_mut<ContractState>(@CoinModule);
            assert!(state.circulating + amount <= state.max_supply, ERROR_LIMIT_EXCEEDED);
            state.circulating = state.circulating + amount;
            coin::pack_coin(amount)
        }

        // When called with a coin as parameter, burn takes ownership of
        // the coin instance. It deconstructs it by passing ownership into
        // the coin module's unpack_coin function. There, the coin struct
        // gets deconstructed and deleted.
        public fun burn(c : Coin): u64 acquires ContractState {
            let state = borrow_global_mut<ContractState>(@CoinModule);
            let amount = coin::unpack_coin(c);
            state.circulating = state.circulating - amount;
            amount
        }

        // Determine if the coin manager has been initialized.
        public fun is_initialized(): bool {
            exists<ContractState>(@CoinModule)
        }

        // Transfer the coin provided in the first parameter to the address
        // specified in variable to.
        public fun transfer(c: Coin, to: address) {
            assert!(coin::has_resource(to), ERROR_NO_RESOURCE);
            coin::merge_coin_to(c, to);
        }

        // Returns the total number of coins that are circulating.
        public fun total_circulating(): u64 acquires ContractState {
            let state = borrow_global<ContractState>(@CoinModule);
            state.circulating
        }
    }
}