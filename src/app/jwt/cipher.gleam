import antigone
import gleam/bit_array

pub fn pass_crypt(pass: String) -> String {
  let pass_to_hash = bit_array.from_string(pass)
  antigone.hash(antigone.hasher(), pass_to_hash)
}

pub fn verify_pass(pass: String, hash: String) -> Bool {
  let pass_to_verify = bit_array.from_string(pass)
  antigone.verify(pass_to_verify, hash)
}
