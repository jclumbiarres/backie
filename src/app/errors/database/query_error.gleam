import gleam/int
import pog

pub fn handle_query_error(err: pog.QueryError) -> String {
  case err {
    pog.ConstraintViolated(message: msg, ..) -> "Error de restricción: " <> msg
    pog.PostgresqlError(message: msg, ..) -> "Error de PostgreSQL: " <> msg
    pog.UnexpectedArgumentCount(expected: exp, got: got) ->
      "Número incorrecto de argumentos. Esperados: "
      <> int.to_string(exp)
      <> ", Recibidos: "
      <> int.to_string(got)
    pog.UnexpectedArgumentType(expected: exp, got: got) ->
      "Tipo de argumento incorrecto. Esperado: " <> exp <> ", Recibido: " <> got
    pog.UnexpectedResultType(_) -> "Error al decodificar el resultado"
    pog.QueryTimeout -> "La consulta excedió el tiempo límite"
    pog.ConnectionUnavailable -> "No se pudo conectar a la base de datos"
  }
}
