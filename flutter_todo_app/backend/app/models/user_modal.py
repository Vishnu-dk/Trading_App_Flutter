
from app.depends.database import Base
from sqlalchemy import Column,String,Integer

class User_Modal(Base):
    __tablename__="users"
    
    email=Column(String,unique=True,nullable=False,index=True,primary_key=True)
    password=Column(String,nullable=False)
    username=Column(String,unique=True,)