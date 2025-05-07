import gwt

pub fn token_validate_error(err: gwt.JwtDecodeError) -> String {
  case err {
    gwt.MissingHeader -> "Missing header."
    gwt.MissingPayload -> "Missing payload."
    gwt.MissingSignature -> "Missing signature."
    gwt.InvalidHeader -> "Invalid header."
    gwt.InvalidPayload -> "Invalid payload."
    gwt.InvalidSignature -> "Invalid signature."
    gwt.InvalidExpiration -> "Invalid expiration claim."
    gwt.TokenExpired -> "Token expired."
    gwt.TokenNotValidYet -> "Token not valid yet."
    gwt.InvalidNotBefore -> "Invalid not_before claim."
    gwt.NoAlg -> "No algorithm specified."
    gwt.InvalidAlg -> "Invalid algorithm."
    gwt.UnsupportedSigningAlgorithm -> "Unsupported signing algorithm."
    gwt.InvalidClaim(_) -> "Invalid claim format or value."
    _ -> "Unknown error"
  }
}
