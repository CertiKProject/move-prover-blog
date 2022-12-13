script {
    use std::debug;
    use std::signer;
    use CoinModule::coin;
    use CoinModule::coin_manager;

    fun airdrop(account: signer, amount: u64, to: signer) {
        assert!(coin_manager::is_initialized(), 1);
        assert!(signer::address_of(&account) == @CoinModule, 1);

        // Register the resource if that has not happened, yet.
        if (!coin::has_resource(signer::address_of(&to))) {
            coin_manager::add_resource(&to);
        };

        // Create a Coin and transfer it.
        let coin = coin_manager::mint(account, amount);
        coin_manager::transfer(coin, signer::address_of(&to));

        debug::print(&amount);
        debug::print(&coin::balance(signer::address_of(&to)));
        debug::print(&coin_manager::total_circulating());
    }
}