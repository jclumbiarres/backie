import app/database/user.{find_user_by_email, find_user_by_username}
import gleam/dynamic/decode
import gleam/json
import gleam/result
import pog
import wisp.{type Request, type Response}
import youid/uuid

/// Maneja solicitudes para encontrar un usuario por su nombre de usuario
pub fn handle_find_by_username(req: Request, db: pog.Connection) -> Response {
  use json_body <- wisp.require_json(req)

  // Decodifica el JSON para obtener el username
  let username_result =
    decode.run(json_body, username_decoder())
    |> result.map_error(fn(_) { "JSON inválido: falta el campo username" })

  case username_result {
    Ok(username) -> {
      // Busca el usuario por username
      case find_user_by_username(db, username) {
        Ok(user) -> {
          // Usuario encontrado, crear respuesta exitosa
          let success_json =
            json.object([
              #(
                "data",
                json.object([
                  #("id", json.string(uuid.to_string(user.id))),
                  #("username", json.string(user.username)),
                  #("email", json.string(user.email)),
                ]),
              ),
            ])
          wisp.json_response(json.to_string_tree(success_json), 200)
        }
        Error(err) -> {
          // Usuario no encontrado, crear respuesta de error
          let err_json =
            json.object([
              #("status", json.string("error")),
              #("message", json.string(err)),
            ])
          wisp.json_response(json.to_string_tree(err_json), 404)
        }
      }
    }
    Error(msg) -> {
      // Error en el formato de la petición
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

/// Maneja solicitudes para encontrar un usuario por su email
pub fn handle_find_by_email(req: Request, db: pog.Connection) -> Response {
  use json_body <- wisp.require_json(req)

  // Decodifica el JSON para obtener el email
  let email_result =
    decode.run(json_body, email_decoder())
    |> result.map_error(fn(_) { "JSON inválido: falta el campo email" })

  case email_result {
    Ok(email) -> {
      // Busca el usuario por email
      case find_user_by_email(db, email) {
        Ok(user) -> {
          // Usuario encontrado, crear respuesta exitosa
          let success_json =
            json.object([
              #(
                "data",
                json.object([
                  #("id", json.string(uuid.to_string(user.id))),
                  #("username", json.string(user.username)),
                  #("email", json.string(user.email)),
                ]),
              ),
            ])
          wisp.json_response(json.to_string_tree(success_json), 200)
        }
        Error(err) -> {
          // Usuario no encontrado, crear respuesta de error
          let err_json =
            json.object([
              #("status", json.string("error")),
              #("message", json.string(err)),
            ])
          wisp.json_response(json.to_string_tree(err_json), 404)
        }
      }
    }
    Error(msg) -> {
      // Error en el formato de la petición
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

// Decodificador para extraer el campo username del JSON
fn username_decoder() -> decode.Decoder(String) {
  use username <- decode.field("username", decode.string)
  decode.success(username)
}

// Decodificador para extraer el campo email del JSON
fn email_decoder() -> decode.Decoder(String) {
  use email <- decode.field("email", decode.string)
  decode.success(email)
}
