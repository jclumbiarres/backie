import app/errors/jwt/validate.{token_validate_error}
import app/jwt/signer.{validate_token}
import app/router
import cors_builder as cors
import dot_env as dot
import envoy
import gleam/erlang/process
import gleam/http
import gleam/io
import gleam/result

import mist
import pog
import wisp
import wisp/wisp_mist

pub fn cors_config() {
  cors.new()
  |> cors.allow_origin("http://localhost:5173")
  |> cors.allow_method(http.Get)
  |> cors.allow_method(http.Post)
  |> cors.allow_method(http.Options)
  |> cors.allow_header("content-type")
  |> cors.allow_header("authorization")
}

pub fn main() {
  dot.new()
  |> dot.set_path(".env")
  |> dot.set_debug(False)
  |> dot.load

  let db = case read_connection_uri() {
    Ok(connection) -> connection
    Error(_) -> {
      io.println("DATABASE_URL environment variable not found.")
      panic as "DATABASE_URL not found"
    }
  }
  let token_prueba = signer.generate_refresh_token("joe-bananas")
  // let token_prueba =
  //   "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJqb2UtYmFuYW5hcyIsIm5iZiI6MTc0NjU1MDg1NSwianRpIjoicmVmcmVzaC0xNzQ2NTUwODU1IiwiaXNzIjoieW91ci1hcHAtbmFtZSIsImlhdCI6MTc0NjU1MDg1NSwiZXhwIjoxNzQ3MTU1NjU1fQ.BFI5jOebigTM_nfM-DLP1uJ6_tLUudsGqUyhxiSpbW-e6C29oIk0fMArzyVn_OV7ogPeVkylZxfZKW53v_hkiA"
  io.println(token_prueba)

  case validate_token(token_prueba) {
    Ok(_) -> io.println("Token is valid.")
    Error(err) ->
      io.println("Token validation error: " <> token_validate_error(err))
  }

  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)

  // Create a CORS-enabled handler
  let cors_handler = fn(req) {
    use req <- cors.wisp_middleware(req, cors_config())
    router.handle_request(db, req)
  }

  let assert Ok(_) =
    wisp_mist.handler(cors_handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn read_connection_uri() -> Result(pog.Connection, Nil) {
  use database_url <- result.try(envoy.get("DATABASE_URL"))
  use config <- result.try(pog.url_config(database_url))
  Ok(pog.connect(config))
}
