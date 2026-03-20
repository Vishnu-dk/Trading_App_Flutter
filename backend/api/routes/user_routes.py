from fastapi import HTTPException,FastAPI,Depends,APIRouter
from sqlalchemy.orm import Session
from depends.database import get_db
from models.user_modal import User
from models.portfolio_modal import Portfolio
from models.wishlist_modal import WishList
from schemas.trade import TradeRequest

router=APIRouter()


@router.get("/user/trade_acccount_balance")
def check_trade_acccount_balance(username:str,db:Session=Depends(get_db)):
    user=db.query(User).filter(User.username==username).first()
    if not user:
        raise HTTPException(status_code=404,detail="User Not Found")
    return {
        "user":user.username,
        "trade_account_balance":user.trade_acccount_balance
    }



@router.post("/user/buy")
def buy_stock_trade(trade:TradeRequest,db:Session=Depends(get_db)):
    user=db.query(User).filter(User.username==trade.username).first()
    if not user:
        raise HTTPException(status_code=404,detail="Not FOUND User")
    total_cost=trade.quantity*trade.price

    if total_cost>user.trade_acccount_balance:
        raise HTTPException(status_code=400,detail="insufficent trade_acccount_balance")
    user.trade_acccount_balance-=total_cost

    portfolio=db.query(Portfolio).filter(Portfolio.symbol==trade.symbol,Portfolio.user_username==trade.username).first()
    
    if portfolio:
        total_quantity=portfolio.quantity+trade.quantity
        portfolio.avg_price=((portfolio.avg_price*portfolio.quantity)+total_cost)/total_quantity
        portfolio.quantity=total_quantity
    else:
        new_portfolio=Portfolio(
            user_username=user.username,
            symbol=trade.symbol,
            quantity=trade.quantity,
            avg_price=trade.price
            )
        db.add(new_portfolio)
    db.commit()
    return{
        "message":"Stock Added",
        "details":[portfolio.symbol,user.username,user.trade_acccount_balance,portfolio.quantity]
    }

@router.post("/user/sell")
def sell_stock_trade(trade:TradeRequest,db:Session=Depends(get_db)):
    user=db.query(User).filter(User.username==trade.username).first()
    if not user:
        raise HTTPException(status_code=404,detail="User missing")
    total_cost=trade.quantity*trade.price

    portfolio_stock=db.query(Portfolio).filter(Portfolio.symbol==trade.symbol,Portfolio.user_username==trade.username).first()
    if not portfolio_stock:
        raise HTTPException(status_code=404,detail="Stock not Found")
    if trade.quantity<portfolio_stock.quantity:
        portfolio_stock.quantity-=trade.quantity
    else:
        db.delete(portfolio_stock)
    user.trade_acccount_balance+=total_cost
    db.commit()
    return{
        "message":"Stock Removed",
        "details":[portfolio_stock.symbol,user.username,user.trade_acccount_balance,portfolio_stock.quantity]
    }



@router.get("/user/portfolio")
def portfolio_details(username:str,db:Session=Depends(get_db)):

    user=db.query(User).filter(User.username==username).first()

    if not user:
        raise HTTPException(status_code=404,detail="user Not Found")
    
    portfolio_stock=db.query(Portfolio).filter(Portfolio.user_username==username).all()
    if not portfolio_stock:
        raise HTTPException(status_code=404,detail="No Stocks Left")

    total_invested=0.0
    total_current=0.0

    portfolio_stock_list=[]

    for stock in portfolio_stock:
        live_price=stock.avg_price*1.1

        invested_amt=stock.avg_price*stock.quantity
        current_amt=live_price*stock.quantity

        total_current+=current_amt
        total_invested+=invested_amt

        portfolio_stock_list.append({
            "symbol":stock.symbol,
            "quantity":stock.quantity,
            "avg_price":stock.avg_price,
            "live_price":live_price,
            "Invested amount":invested_amt,
            "Current Amount":current_amt
        })

    return portfolio_stock_list

@router.post("/user/deposit")
def deposit_money(username: str, amount: float, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    
    user.trade_acccount_balance += amount
    db.commit()
    return {"new_balance": user.trade_acccount_balance, "message": "Deposit Successful"}
 
@router.post("/user/withdraw")
def withdraw_money(username: str, amount: float, db: Session = Depends(get_db)):
    user = db.query(User).filter(User.username == username).first()
    if user.trade_acccount_balance < amount:
        raise HTTPException(status_code=400, detail="Insufficient funds")
    
    user.trade_acccount_balance -= amount
    db.commit()
    return {"new_balance": user.trade_acccount_balance, "message": "Withdrawal Successful"}


@router.post("/user/wishlist/toggle")
def toggle_wishlist(data: dict, db: Session = Depends(get_db)):

    item = db.query(WishList).filter(
        WishList.user_username == "Vishnu", 
        WishList.symbol == data['symbol']
    ).first()
 
    if item:
        db.delete(item)
        db.commit()
        return {"status": "removed", "symbol": data['symbol']}
    else:
        new_item = WishList(user_username= "Vishnu", symbol=data['symbol'])
        db.add(new_item)
        db.commit()
        return {"status": "added", "symbol": data['symbol']}
 
@router.get("/user/wishlist")
def get_wishlist(db: Session = Depends(get_db)):
    items = db.query(WishList).filter(WishList.user_username == "Vishnu").all()
    return [i.symbol for i in items] 