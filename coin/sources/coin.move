// A simple coin example to show the Move Prover's capabilities
// Originally intended for a blog about the Move Prover.

// Idea:     Define a token contract in Move and make use of the Move specific ownership features.
//           Encapsulate the Coin resource as much as possible and define a ghost variable that
//           the specification updates whenever a coin is created or destroyed.
//           That ghost variable keeps track of the total number of coins that are circulating at
//           any given point in time.
// Origin:   This example originates from a paragraph in the MSL manual that hints at such a use case:
//           https://github.com/diem/diem/blob/release-1.5/language/move-prover/doc/user/spec-lang.md#specification-variables
//           However, that syntax (and, I fear, the entire functionality behind it) have been removed without
//           replacement. It is not essential, though and can be mimicked by carefully treating Coins as abstract
//           data types. In that way, one can define functions `pack` and `unpack` and make them keep track of
//           the number of coins using ghost variable (`sum_of_all_coins`).

address CoinModule {
    module coin {
        // This friend specification allows the coin manager to access public coin
        // functions that have the public(friend) visibility. By declaring coin_manager
        // as a friend, we essentially give that contract elevated priviledges such as
        // packing, unpacking, and moving coins.
        friend CoinModule::coin_manager;

        // The Coin resource that encapsulates the actual amount of coins.
        struct Coin has key, store {
            amount: u64
        }

        // Internal function to create coins. All coins _must_ be created via
        // this function.
        public(friend) fun pack_coin(amount: u64): Coin {
            Coin { amount }
        }

        // All coins must be deconstructed via this function or the merge_coin_to
        // function.
        public(friend) fun unpack_coin(coin: Coin): u64 {
            let Coin { amount } = coin;
            amount
        }

        public(friend) fun merge_coin_to(c: Coin, to: address) : u64 acquires Coin {
            let Coin { amount: from_amount } = c;
            let dst = borrow_global_mut<Coin>(to);
            dst.amount = dst.amount + from_amount;
            from_amount
        }

        public fun has_resource(account: address): bool {
            exists<Coin>(account)
        }

        // Adds a Coin resource to the signer. Only then may the signer receive or send Coins.
        // NB: Air drops as on Ethereum are impossible - you need to have the recipient's consent
        // before storing any data under her account.
        public fun add_resource(account: &signer) {
            let empty_coin = pack_coin(0);
            move_to<Coin>(account, empty_coin);
        }

        public fun amount(c : &Coin): u64 {
            c.amount
        }

        public fun balance(account: address): u64 acquires Coin {
            amount(borrow_global<Coin>(account))
        }

        // fun counterfeiter(coin: Coin): (Coin, Coin) {
        //     let duplicate = copy coin;
        //     (coin, duplicate)
        // }
   }
}