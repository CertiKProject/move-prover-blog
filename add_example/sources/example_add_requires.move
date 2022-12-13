module 0x01::SimpleAddRequires {
  public fun add(x : u64, y : u64) : u64 {
    x + y
  }

  spec add(x : u64, y : u64) : u64 {
    requires x + y <= MAX_U64;
    ensures result == x + y;
  }
}