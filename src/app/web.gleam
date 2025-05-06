import birl
import birl/duration
import gleam/http
import gleam/int
import gleam/io
import wisp

pub fn middleware(
  req: wisp.Request,
  handle_request: fn(wisp.Request) -> wisp.Response,
) -> wisp.Response {
  let req = wisp.method_override(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)

  let start_time = birl.now()
  let response = handle_request(req)
  let end_time = birl.now()

  let duration_value = birl.difference(end_time, start_time)
  let duration_ms = duration.blur_to(duration_value, duration.MilliSecond)
  let method = http.method_to_string(req.method)
  let path = req.path
  let status = int.to_string(response.status)
  let ms_string = int.to_string(duration_ms)

  // Log method, path, status, and duration in ms
  io.println(
    method <> " " <> path <> " -> " <> status <> " (" <> ms_string <> "ms)",
  )
  response
}
