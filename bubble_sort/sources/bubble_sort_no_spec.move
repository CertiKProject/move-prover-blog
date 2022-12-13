address bubble_sort {

    module bubble_sort_no_spec {
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
        }
    }
}