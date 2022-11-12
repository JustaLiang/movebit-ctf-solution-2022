module 0x0::open_box {
    use std::hash;
    use std::vector;
    use sui::bcs;
    use sui::tx_context::TxContext;
    use sui::object;
    use game::hero::{Self, Hero};
    use game::adventure;
    use game::inventory::{Self, TreasuryBox};

    const ERR_HIGH_ARG_GREATER_THAN_LOW_ARG: u64 = 101;

    public fun vector_slice<T: copy>(vec: &vector<T>, start: u64, end: u64): vector<T> {
        let slice = vector::empty<T>();
        let i = start;
        while (i < end) {
            vector::push_back(&mut slice, *vector::borrow(vec, i));
            i = i + 1;
        };
        slice
    }

    public fun vector_to_u64(d: &vector<u8>): u64 {
        let i = 0;
        let m = 0;
        let len = vector::length(d);
        while (i < vector::length(d)) {
            m = (m << 8) + ((*vector::borrow(d, len - 1 - i)) as u64);
            i = i + 1;
        };
        m
    }

    public fun u64_to_vector(d: u64): vector<u8> {
        bcs::to_bytes(&d)
    }

    public fun seed(ctx: &mut TxContext, m: u64): vector<u8> {
        let ctx_bytes = bcs::to_bytes(ctx);
        let tx_hash = vector_slice(&ctx_bytes, 21, 21 + ((*vector::borrow(&ctx_bytes, 20)) as u64));
        let len = vector::length(&ctx_bytes);
        let created_vector = vector_slice(&ctx_bytes, len - 8, len);
        let created_num = vector_to_u64(&created_vector) + m;
        let created_vector = u64_to_vector(created_num);
        assert!(created_vector == u64_to_vector(created_num), 1);
        let data = vector::empty<u8>();
        vector::append(&mut data, vector_slice(&ctx_bytes, 0, len - 8));
        vector::append(&mut data, created_vector);
        let ctx_bytes = data;
        let info: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut info, tx_hash);
        vector::append<u8>(&mut info, created_vector);
        let uid_bytes = vector_slice(&hash::sha3_256(info), 0, 20);
        let info: vector<u8> = vector::empty<u8>();
        vector::append<u8>(&mut info, ctx_bytes);
        vector::append<u8>(&mut info, uid_bytes);
        let hash: vector<u8> = hash::sha3_256(info);
        hash
    }

    fun bytes_to_u64(bytes: vector<u8>): u64 {
        let value = 0u64;
        let i = 0u64;
        while (i < 8) {
            value = value | ((*vector::borrow(&bytes, i) as u64) << ((8 * (7 - i)) as u8));
            i = i + 1;
        };
        return value
    }

    /// Generate a random u64
    fun rand_u64_with_seed(_seed: vector<u8>): u64 {
        bytes_to_u64(_seed)
    }

    /// Generate a random integer range in [low, high).
    fun rand_u64_range_with_seed(_seed: vector<u8>, low: u64, high: u64): u64 {
        assert!(high > low, ERR_HIGH_ARG_GREATER_THAN_LOW_ARG);
        let value = rand_u64_with_seed(_seed);
        (value % (high - low)) + low
    }

    /// Generate a random u64
    public fun rand_u64(ctx: &mut TxContext): u64 {
        rand_u64_with_seed(seed(ctx, 0))
    }

    /// Generate a random integer range in [low, high).
    public fun rand_u64_range(low: u64, high: u64, ctx: &mut TxContext): u64 {
        rand_u64_range_with_seed(seed(ctx, 0), low, high)
    }

    public entry fun get_treasury_box(hero: &mut Hero, ctx: &mut TxContext) {
        let i = 0;
        while (i < 125) {
            adventure::slay_boar(hero, ctx);
            i = i + 1;
        };
        hero::level_up(hero);
        let next = next_zero_rand_u64_range(0, 100, ctx) - 4;
        while (next > 0) {
            object::delete(object::new(ctx));
            next = next - 1;
        };
        adventure::slay_boar_king(hero, ctx);
    }

    public fun next_zero_rand_u64_range(low: u64, high: u64, ctx: &mut TxContext): u64 {
        let next = 0;
        while (true) {
            let data = rand_u64_range_with_seed(seed(ctx, next), low, high);
            if ((data == 0) && (next >= 4)) {
                break
            };
            next = next + 1;
        };
        next
    }
    
    public entry fun catch_flag(box: TreasuryBox, ctx: &mut TxContext) {
        let next = next_zero_rand_u64_range(0, 100, ctx);
        while (next > 0) {
            object::delete(object::new(ctx));
            next = next - 1;
        };
        inventory::get_flag(box, ctx);
    }
}