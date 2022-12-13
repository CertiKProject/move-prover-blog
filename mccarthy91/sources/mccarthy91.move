address McCarthy91 {

    module mccarthy91 {

        public fun mc91(n: u64): u64 {
            if (n > 100)
                n - 10
            else
                mc91(mc91(n + 11))
        }

        spec mc91 {
            pragma opaque;
            aborts_if false;
            ensures (n <= 100 ==> result == 91);
            ensures (n > 100 ==> result == n - 10);
        }
    }
}