select id,
    username,
    email
from users
where username = $1;