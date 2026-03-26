import os
from sqlalchemy import create_engine
from sqlalchemy.engine import URL
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
from sqlalchemy.exc import OperationalError
import time

load_dotenv()

DATABASE_URL=URL.create(
    "postgresql+psycopg2",
    username=os.getenv("POSTGRES_USER","postgres"),
    password=os.getenv("POSTGRES_PASSWORD","Kripa@123"),
    database=os.getenv("POSTGRES_DB","todo_db"),
    host=os.getenv("POSTGRES_HOST","db"),
    port=int(os.getenv("POSTGRES_PORT","5432")),
)

Base=declarative_base()

engine=create_engine(DATABASE_URL)
SessionLocal=sessionmaker(autoflush=False,autocommit=False,bind=engine)


def connect_db():
    retries = 15
    while retries > 0:
        try:
            with engine.connect() as connection:
                print("Database connected successfully!")
                return # Exit the function entirely
        except (OperationalError, Exception) as e:
            print(f" DB not ready... {retries} retries left. (Error: {e})")
            retries -= 1
            time.sleep(3)
    
    raise Exception(" Could not connect to DB")


def get_db():
    db=SessionLocal()
    try:
        yield db


    finally:
        db.close()

