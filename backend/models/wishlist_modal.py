
from depends.database import Base
from sqlalchemy import Column,Integer,String,Float,ForeignKey


class WishList(Base):
    __tablename__="wishlist"
    symbol=Column(String,primary_key=True,index=True)
    user_username=Column(String,ForeignKey("users.username"))


