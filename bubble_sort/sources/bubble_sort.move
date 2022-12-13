address bubble_sort {

    module bubble_sort {
        use std::vector;

        // Bubble sort that operates in place.
        public fun sort(elems: &mut vector<u64>) {
            if (vector::length(elems) < 2) return;

            let i = 0;
            let swapped = false;
            while ({
                // Loop invariants are defined within the loop head.
                spec {
                    invariant !swapped ==> (forall j in 0..i: elems[j] <= elems[j + 1]);
                    invariant len(elems) == len(old(elems));
                    invariant forall a in old(elems): contains(elems, a);
                    invariant forall a in elems: contains(old(elems), a);
                };
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
            ensures forall i in 0..len(elems)-1: elems[i] <= elems[i+1];
            ensures forall a in old(elems): contains(elems, a);
            ensures forall a in elems: contains(old(elems), a);
            ensures len(elems) == len(old(elems));
        }
    }
}