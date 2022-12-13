address McCarthy91 {

    module mccarthy91_bug {

        public fun mc91_buggy(n: u64): u64 {
            if (n > 99)
                n - 10
            else
                mc91_buggy(mc91_buggy(n + 11))
        }

        spec mc91_buggy {
            pragma opaque;
            aborts_if false;
            ensures (n <= 100 ==> result == 91);
            ensures (n > 100 ==> result == n - 10);
        }
    }
}