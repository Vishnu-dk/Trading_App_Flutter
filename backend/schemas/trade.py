from pydantic import BaseModel


class TradeRequest(BaseModel):
    username:str
    symbol:str
    quantity:int
    price:float