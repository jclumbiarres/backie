import app/jwt/cipher
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
    Error(_) -> Error("Error al insertar usuario")
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
    Error(_) -> Error("Error al buscar")
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
    Error(_) -> Error("Error al buscar")
  }
}
