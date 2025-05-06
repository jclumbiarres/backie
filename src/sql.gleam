import gleam/dynamic/decode
import pog
import youid/uuid.{type Uuid}

/// A row you get from running the `find_user` query
/// defined in `./src/sql/find_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.3 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindUserRow {
  FindUserRow(id: Uuid, username: String, email: String)
}

/// Runs the `find_user` query
/// defined in `./src/sql/find_user.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.3 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_user(db, arg_1, arg_2) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    use email <- decode.field(2, decode.string)
    decode.success(FindUserRow(id:, username:, email:))
  }

  "select id,
    username,
    email
from users
where username = $1
    and email = $2;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_user_by_username` query
/// defined in `./src/sql/find_user_by_username.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.3 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindUserByUsernameRow {
  FindUserByUsernameRow(id: Uuid, username: String, email: String)
}

/// Runs the `find_user_by_username` query
/// defined in `./src/sql/find_user_by_username.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.3 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_user_by_username(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    use email <- decode.field(2, decode.string)
    decode.success(FindUserByUsernameRow(id:, username:, email:))
  }

  "select id,
    username,
    email
from users
where username = $1;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `find_user_by_email` query
/// defined in `./src/sql/find_user_by_email.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.3 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type FindUserByEmailRow {
  FindUserByEmailRow(id: Uuid, username: String, email: String)
}

/// Runs the `find_user_by_email` query
/// defined in `./src/sql/find_user_by_email.sql`.
///
/// > 🐿️ This function was generated automatically using v3.0.3 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn find_user_by_email(db, arg_1) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    use email <- decode.field(2, decode.string)
    decode.success(FindUserByEmailRow(id:, username:, email:))
  }

  "select id,
    username,
    email
from users
where email = $1;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

/// A row you get from running the `insert_user` query
/// defined in `./src/sql/insert_user.sql`.
///
/// > 🐿️ This type definition was generated automatically using v3.0.3 of the
/// > [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub type InsertUserRow {
  InsertUserRow(id: Uuid, username: String, email: String)
}

/// Insert a new user into the users table
///
/// > 🐿️ This function was generated automatically using v3.0.3 of
/// > the [squirrel package](https://github.com/giacomocavalieri/squirrel).
///
pub fn insert_user(db, arg_1, arg_2, arg_3) {
  let decoder = {
    use id <- decode.field(0, uuid_decoder())
    use username <- decode.field(1, decode.string)
    use email <- decode.field(2, decode.string)
    decode.success(InsertUserRow(id:, username:, email:))
  }

  "-- Insert a new user into the users table
INSERT INTO users (username, email, password)
VALUES ($1, $2, $3)
RETURNING id,
    username,
    email;"
  |> pog.query
  |> pog.parameter(pog.text(arg_1))
  |> pog.parameter(pog.text(arg_2))
  |> pog.parameter(pog.text(arg_3))
  |> pog.returning(decoder)
  |> pog.execute(db)
}

// --- Encoding/decoding utils -------------------------------------------------

/// A decoder to decode `Uuid`s coming from a Postgres query.
///
fn uuid_decoder() {
  use bit_array <- decode.then(decode.bit_array)
  case uuid.from_bit_array(bit_array) {
    Ok(uuid) -> decode.success(uuid)
    Error(_) -> decode.failure(uuid.v7(), "Uuid")
  }
}
