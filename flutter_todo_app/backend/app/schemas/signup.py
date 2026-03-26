from pydantic import BaseModel,EmailStr

class Display(BaseModel):
    email:EmailStr
    username:str|None=None

class Sign_Up(Display):
        password:str