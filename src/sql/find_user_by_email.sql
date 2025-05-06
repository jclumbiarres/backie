select id,
    username,
    email
from users
where email = $1;