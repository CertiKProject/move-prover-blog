address bubble_sort {
        module bubble_sort_aborts {
        use std::vector;

        // Bubble sort that operates in place.
        public fun sort(elems: &mut vector<u64>) {
            if (vector::length(elems) < 2) return;

            let i = 0;
            let swapped = false;
            while ({
                // Loop invariants are defined within the loop head.
                spec { invariant len(elems) == len(old(elems)); };
                i < vector::length(elems) - 1
            })
            {
                if (*vector::borrow(elems, i) > *vector::borrow(elems, i + 1)) {
                    vector::swap(elems, i, i + 1);
                    swapped = true;
                };
                i = i + 1;
            };
            if (swapped) sort(elems);
        }

        spec sort {
            pragma opaque;
            aborts_if false;
            ensures len(elems) == len(old(elems));
        }
    }
}