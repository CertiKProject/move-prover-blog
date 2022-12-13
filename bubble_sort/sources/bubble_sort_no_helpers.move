address bubble_sort {

    module bubble_sort_no_helpers {
        use std::vector;

        public fun sort(elems: &mut vector<u64>) {
            if (vector::length(elems) < 2) return;

            let i = 0;
            let swapped = false;
            while (i < vector::length(elems) - 1) {
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
            ensures len(elems) == len(old(elems));
        }
    }
}