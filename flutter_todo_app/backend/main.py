from fastapi import FastAPI
from app.depends.database import engine, Base, connect_db
from app.depends.database import SessionLocal,engine
from app.models.todo_model import Todo_Modal
from app.models.user_modal import User_Modal
from fastapi.middleware.cors import CORSMiddleware

from app.routes.user_routes import router as user
from app.routes.todo_list_routes import router as todo


# Base.metadata.create_all(bind=engine)
 

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]

)
 
@app.get("/")
def read_root():
    return {"status": "Database Connected and App Live"}

app.include_router(user)
app.include_router(todo)

