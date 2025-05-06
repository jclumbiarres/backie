select id,
    username,
    email
from users
where username = $1
    and email = $2;