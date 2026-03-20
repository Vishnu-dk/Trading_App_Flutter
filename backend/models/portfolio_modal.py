from depends.database import Base
from sqlalchemy import Column,Integer,String,Float,ForeignKey


class Portfolio(Base):
    __tablename__="portfolios"
    symbol=Column(String,primary_key=True,index=True)
    user_username=Column(String,ForeignKey("users.username"))

    quantity=Column(Integer)
    avg_price=Column(Float)
