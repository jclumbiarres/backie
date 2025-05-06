import app/user/find
import app/user/register.{handle_form_submission}
import app/web
import gleam/http.{Get, Post}
import gleam/http/request
import gleam/json
import pog
import wisp.{type Request, type Response}

pub fn handle_request(db: pog.Connection, req: Request) -> Response {
  use req <- web.middleware(req)

  let path = request.path_segments(req)

  case path, req.method {
    [], Get -> handle_root()
    ["user"], Post -> handle_form_submission(req, db)
    ["user", "find", "email"], Post -> find.handle_find_by_email(req, db)
    ["user", "find", "username"], Post -> find.handle_find_by_username(req, db)
    _, _ -> wisp.not_found()
  }
}

fn handle_root() -> Response {
  let body =
    json.object([
      #("status", json.string("Ok")),
      #("message", json.string("API Working")),
    ])
  wisp.json_response(json.to_string_tree(body), 200)
}
