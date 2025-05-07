import app/database/user.{type NewUser, CreateUser, insert_user}
import gleam/dynamic/decode
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

// Decoder para consumir JSON en lugar de form-data
fn new_user_decoder() -> decode.Decoder(NewUser) {
  use username <- decode.field("username", decode.string)
  use email <- decode.field("email", decode.string)
  use password <- decode.field("password", decode.string)
  decode.success(CreateUser(username:, email:, password:))
}

pub fn handle_form_submission(req: Request, db: pog.Connection) -> Response {
  // 1) Lee body JSON
  use json_body <- wisp.require_json(req)

  // 2) Decodifica a NewUser usando nuestro decoder
  let user_data_res =
    decode.run(json_body, new_user_decoder())
    |> result.map_error(fn(_) {
      // Convierte errores de decode a String
      "JSON inválido: "
    })

  case user_data_res {
    Ok(user_data) ->
      // 3) Inserta en DB
      case insert_user(db, user_data) {
        Ok(created) -> {
          let success_json =
            json.object([
              #("status", json.string("success")),
              #("message", json.string("Usuario registrado correctamente")),
              #(
                "data",
                json.object([
                  #("id", json.string(uuid.to_string(created.id))),
                  #("username", json.string(created.username)),
                  #("email", json.string(created.email)),
                ]),
              ),
            ])
          wisp.created()
          |> wisp.json_body(json.to_string_tree(success_json))
        }
        Error(err) -> {
          let err_json =
            json.object([
              #("status", json.string("error")),
              #("message", json.string(err)),
            ])
          wisp.internal_server_error()
          |> wisp.json_body(json.to_string_tree(err_json))
        }
      }
    Error(msg) -> {
      let err_json =
        json.object([
          #("status", json.string("error")),
          #("message", json.string(msg)),
        ])
      wisp.bad_request()
      |> wisp.json_body(json.to_string_tree(err_json))
    }
  }
}
