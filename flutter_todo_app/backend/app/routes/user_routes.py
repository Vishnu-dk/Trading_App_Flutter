from fastapi import APIRouter,Depends,HTTPException
from app.schemas.signup import Sign_Up,Display
from app.schemas.login import Login
from sqlalchemy.orm import Session
from sqlalchemy import or_
from app.depends.database import get_db
from app.models.user_modal import User_Modal
from app.models.todo_model import Todo_Modal
from app.depends.auth import verifying_password,hashing_password,DUMMY_PASS,create_Token,get_user


router=APIRouter()

@router.post("/signup")
def user_signup(user:Sign_Up,db:Session=Depends(get_db)):
    try:
        existing=db.query(User_Modal).filter(or_(User_Modal.email==user.email,User_Modal.username==user.username)).first()
        
        if existing:
            raise HTTPException(status_code=400,detail="User Already Exists")
            return null
        
        hashed_password=hashing_password(user.password)
        current_user=User_Modal(email=user.email,username=user.username,password=hashed_password)
        db.add(current_user)
        db.commit()
        db.refresh(current_user)
        return "User Created"
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        print(f"server errror :{e}")
        raise HTTPException(status_code=500,detail= "Server Error")
    


@router.post("/login")
def user_login(user:Login,db:Session=Depends(get_db)):
    try:
        existing=db.query(User_Modal).filter(User_Modal.email==user.email).first()
        if not existing:
            result=verifying_password(user.password,DUMMY_PASS)

            raise HTTPException(status_code=404,detail="Invalid Credentials")
        check=verifying_password(user.password,existing.password)
        
        if not check:
            raise HTTPException(status_code=404,detail="Invalid Credentials")
        token=create_Token(user.email)
        return {"message":"User Logged IN!!", "access_token":token}

    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        print(f"server errror :{e}")
        raise HTTPException(status_code=500,detail= "Server Error")
    
@router.get("/user_details",response_model=Display)
def get_user_detials(current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        existing_user=db.query(User_Modal).filter(User_Modal.email==current_user).first()
        if not existing_user:
            raise HTTPException(status_code=404,detail="Invalid Tocken")
        return existing_user
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,detail="Internal Server Error")