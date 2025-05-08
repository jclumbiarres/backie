import app/errors/database/query_error.{handle_query_error}
import app/jwt/cipher
import gleam/result
import sql
import youid/uuid.{type Uuid}

pub type User {
  User(id: Uuid, username: String, email: String)
}

pub type NewUser {
  CreateUser(username: String, email: String, password: String)
}

fn from_find_by_username_row(row: sql.FindUserByUsernameRow) -> User {
  User(id: row.id, username: row.username, email: row.email)
}

fn from_find_by_email_row(row: sql.FindUserByEmailRow) -> User {
  User(id: row.id, username: row.username, email: row.email)
}

fn from_insert_user_row(row: sql.InsertUserRow) -> User {
  User(id: row.id, username: row.username, email: row.email)
}

pub fn insert_user(db, user: NewUser) -> Result(User, String) {
  let hash_password = cipher.pass_crypt(user.password)
  case sql.insert_user(db, user.username, user.email, hash_password) {
    Ok(returned) -> {
      case returned.rows {
        [row, ..] -> Ok(from_insert_user_row(row))
        [] -> Error("No se pudo insertar el usuario")
      }
    }
    Error(err) -> Error(handle_query_error(err))
  }
}

pub fn find_user_by_username(db, user: String) -> Result(User, String) {
  case sql.find_user_by_username(db, user) {
    Ok(found_user) -> {
      case found_user.rows {
        [row, ..] -> {
          let user = from_find_by_username_row(row)
          Ok(user)
        }
        [] -> {
          Error("No se encontraron usuarios")
        }
      }
    }
    Error(err) -> Error(handle_query_error(err))
  }
}

pub fn find_user_by_username_v2(db, username: String) -> Result(User, String) {
  sql.find_user_by_username(db, username)
  |> result.map_error(handle_query_error)
  |> result.then(fn(found_user) {
    found_user.rows
    |> extract_first_user_row
  })
}

fn extract_first_user_row(rows) -> Result(User, String) {
  case rows {
    [row, ..] -> Ok(from_find_by_username_row(row))
    [] -> Error("No se encontraron usuarios")
  }
}

pub fn find_user_by_email(db, email: String) -> Result(User, String) {
  case sql.find_user_by_email(db, email) {
    Ok(found_user) -> {
      case found_user.rows {
        [row, ..] -> {
          let user = from_find_by_email_row(row)
          Ok(user)
        }
        [] -> {
          Error("No se encontraron usuarios")
        }
      }
    }
    Error(err) -> Error(handle_query_error(err))
  }
}
