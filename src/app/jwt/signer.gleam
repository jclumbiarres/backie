import birl
import birl/duration
import envoy
import gleam/io
import gleam/result
import gwt
import youid/uuid

fn calculate_token_timestamps(
  now: birl.Time,
  validity_duration: duration.Duration,
) -> #(Int, Int) {
  let unix_time_now = birl.to_unix(now)
  let expiration_time = birl.add(now, validity_duration)
  let expiration_unix = birl.to_unix(expiration_time)
  #(unix_time_now, expiration_unix)
}

pub fn generate_access_token(user_id: String) -> String {
  let secret_key_base = case read_signer_env("JWT_ACCESS_SECRET") {
    Ok(connection) -> connection
    Error(_) -> {
      io.println("DATABASE_URL environment variable not found.")
      panic as "DATABASE_URL not found"
    }
  }
  let #(unix_time_now, expiration_unix) =
    calculate_token_timestamps(birl.now(), duration.minutes(15))

  let builder =
    gwt.new()
    |> gwt.set_subject(user_id)
    |> gwt.set_issuer("your-app-name")
    |> gwt.set_audience("your-app-frontend")
    |> gwt.set_issued_at(unix_time_now)
    |> gwt.set_not_before(unix_time_now)
    |> gwt.set_expiration(expiration_unix)
    |> gwt.set_jwt_id(uuid.v4_string())

  gwt.to_signed_string(builder, gwt.HS512, secret_key_base)
}

pub fn generate_refresh_token(user_id: String) -> String {
  let refresh_secret = case read_signer_env("JWT_REFRESH_SECRET") {
    Ok(connection) -> connection
    Error(_) -> {
      panic as "DATABASE_URL not found"
    }
  }
  let #(unix_time_now, expiration_unix) =
    calculate_token_timestamps(birl.now(), duration.days(7))

  let builder =
    gwt.new()
    |> gwt.set_subject(user_id)
    |> gwt.set_issuer("your-app-name")
    // No audience needed usually for refresh tokens
    |> gwt.set_issued_at(unix_time_now)
    |> gwt.set_not_before(unix_time_now)
    |> gwt.set_expiration(expiration_unix)
    |> gwt.set_jwt_id(uuid.v4_string())

  gwt.to_signed_string(builder, gwt.HS512, refresh_secret)
}

pub fn read_signer_env(token_type: String) -> Result(String, Nil) {
  use token <- result.try(envoy.get(token_type))
  Ok(token)
}

pub fn validate_token(
  token: String,
) -> Result(gwt.Jwt(gwt.Verified), gwt.JwtDecodeError) {
  let secret_key_base = case read_signer_env("JWT_REFRESH_SECRET") {
    Ok(connection) -> connection
    Error(_) -> {
      io.println("JWT_REFRESH_SECRET environment variable not found.")
      panic as "JWT_REFRESH_SECRET not found"
    }
  }
  case gwt.from_signed_string(token, secret_key_base) {
    Ok(claims) -> Ok(claims)
    Error(err) -> Error(err)
  }
}
