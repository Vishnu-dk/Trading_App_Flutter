from fastapi import FastAPI,Depends
from sqlalchemy.orm import Session
from depends.database import SessionLocal,engine
from sqlalchemy import text
import models 
from sqlalchemy.exc import OperationalError
import time
from fastapi.middleware.cors import CORSMiddleware

from api.routes.user_routes import router as user_routes

models.Base.metadata.create_all(bind=engine)

app=FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

def get_db():
    db=SessionLocal()
    try:
        yield db


    finally:
        db.close()

@app.get("/")
def home():
    return {"message":"backend runing"}


@app.get("/test_db")
def test_db(db:Session=Depends(get_db)):
    try:
        db.execute(text("SELECT 1"))
        return {
            "status":"Database Connected Successfully"
        }
    except Exception as e:
        return {
            "status":"Database Error",
            "details":str(e)
        }
def create_demo():
    db=SessionLocal()
    try:

        user=db.query(models.User).filter(models.User.username=="Vishnu").first()
        print(f"Available keys in User: {models.User.__table__.columns.keys()}")
        if not user:
            new_user=models.User(username="Vishnu",trade_acccount_balance=100000)
            db.add(new_user)
            print(new_user)
            db.commit()


    finally:
        db.close()
    

create_demo()
app.include_router(user_routes)