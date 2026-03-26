from passlib.context import CryptContext
from datetime import datetime, timedelta, timezone
from jose import jwt,JWTError
import os
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from fastapi import Depends,HTTPException
from app.depends.database import get_db

pwd_context=CryptContext(
    schemes=['argon2','bcrypt','bcrypt_sha256'],
    deprecated='auto'
)


DUMMY_PASS=pwd_context.hash("dummypassword")

def hashing_password(password:str)->str:
    return pwd_context.hash(password)

def verifying_password(password:str,hashed_password:str)->bool:
    return pwd_context.verify(password,hashed_password)


SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM", "HS256")

auth2_scheme=OAuth2PasswordBearer(tokenUrl="login")


def create_Token(email:str)->str:
    payload={"email":email}
    expire=datetime.now(timezone.utc ) +timedelta(days=1)
    payload.update({"exp":expire})
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)

def delete_Token(email:str)->str:
    payload={"email":email}
    expire=datetime.now(timezone.utc )
    payload.update({"exp":expire})
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_user(tocken:str=Depends(auth2_scheme) , db:Session=Depends(get_db)):
    try:
        payload=jwt.decode(tocken,SECRET_KEY,algorithms=ALGORITHM)
        email=payload.get("email")
        if not email:
            raise HTTPException(status_code=401,detail="INVALID TOCKEN")
        return email

    except HTTPException:
        raise
    except JWTError:
        raise HTTPException(status_code=401,detail="INVALID TOCKEN")