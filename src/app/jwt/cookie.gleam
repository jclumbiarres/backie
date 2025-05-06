import wisp.{type Request, type Response}

const cookie_name = "refresh"

pub fn cookie_create_session(req: Request, username: String) -> Response {
  wisp.set_cookie(
    req,
    response: wisp.ok(),
    name: cookie_name,
    value: username,
    security: wisp.Signed,
    max_age: 60 * 60 * 24,
  )
}
