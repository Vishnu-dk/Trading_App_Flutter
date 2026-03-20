from depends.database import Base
from sqlalchemy import Column,Integer,String,Float

class User(Base):
    __tablename__="users"
    username=Column(String,unique=True,index=True,primary_key=True,)
    trade_acccount_balance=Column(Float,default=100000)
