from user import User
from database import Database

Database.initialise(database="mydatabase", user="postgres", password="1234", host="172.31.21.30")

user = User('jose@schoolofcode.me', 'Jose', 'Salvatierra')

user.save_to_db()

user_from_db = User.load_from_db_by_email('jose@schoolofcode.me')

print(user_from_db)
