module 0x01::SimpleAddAbortsIf {

  public fun add(x : u64, y : u64) : u64 {
    x + y
  }

  spec add(x : u64, y : u64) : u64 {
    aborts_if x + y > MAX_U64;
    ensures result == x + y;
  }
}