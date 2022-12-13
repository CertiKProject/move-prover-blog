module 0x01::SimpleAddNaive {
  spec module {
      pragma aborts_if_is_strict = true;
  }

  public fun add(x : u64, y : u64) : u64 {
    x + y
  }

  spec add(x : u64, y : u64) : u64 {
    ensures result == x + y;
  }
}