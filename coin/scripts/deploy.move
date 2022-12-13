script {
    use std::signer;
    use CoinModule::coin_manager;

    fun deploy(account: signer, max_supply: u64) {
        assert!(signer::address_of(&account) == @CoinModule, 1);
        coin_manager::init(account, max_supply);
    }
}