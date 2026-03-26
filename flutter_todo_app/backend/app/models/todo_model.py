
from sqlalchemy import Column,Integer,String,Boolean,ForeignKey
from app.depends.database import Base


class  Todo_Modal(Base):
    __tablename__="todo"
    id=Column(Integer,primary_key=True,index=True)
    list_user_email=Column(String,ForeignKey("users.email"))
    title=Column(String,nullable=False)
    description=Column(String)
    isCompleted=Column(Boolean,default=False)