from flask_sqlalchemy import SQLAlchemy
from models import Player
db = SQLAlchemy()

class Player(db.Model):
    __tablename__ = 'players'

    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(100))
    category = db.Column(db.String(50))
    status = db.Column(db.String(20), default='AVAILABLE')