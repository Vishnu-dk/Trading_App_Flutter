

from fastapi import Depends,HTTPException
from sqlalchemy.orm import Session
from app.depends.auth import get_db,get_user
from app.models.todo_model import Todo_Modal
from app.models.user_modal import User_Modal
from app.schemas.todo import TodoDelete,TodoAdd,TodoEdit
from fastapi import APIRouter

router= APIRouter()

@router.post("/add_task")
def add_task(task:TodoAdd,current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        task_exists=db.query(Todo_Modal).filter(Todo_Modal.title==task.title,Todo_Modal.list_user_email==current_user).first()
        if task_exists:
            raise HTTPException(status_code=401,detail="Duplicated Task ")
        new_Todo=Todo_Modal(title=task.title,description=task.description,isCompleted=False,list_user_email=current_user)
        db.add(new_Todo)
        db.commit()
        db.refresh(new_Todo)
        return "Task Added"
    except HTTPException:
        raise
    except Exception:
        raise HTTPException(status_code=500,detail="SERVER ERROR")
    

@router.delete("/delete_task")
def delete_task(task:TodoDelete,current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        exists_task=db.query(Todo_Modal).filter(task.title==Todo_Modal.title,Todo_Modal.list_user_email==current_user).first()
        if not exists_task:
            raise HTTPException(status_code=404,detail="Task Not Found")
        db.delete(exists_task)
        db.commit()
        return "Task Deleted"
    except HTTPException:
        raise
    except Exception :
        raise HTTPException(status_code=500,detail="Server Error")
    
@router.put("/edit_task")
def edit_task(task:TodoEdit,current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        exists_task=db.query(Todo_Modal).filter(Todo_Modal.title==task.oldtitle,Todo_Modal.list_user_email==current_user).first()
        if not exists_task:
            raise HTTPException(status_code=404,detail="Task NOT Found")
        update_todo=task.model_dump(exclude_unset=True,exclude=['oldtitle'])
        for key,value in update_todo.items():
            setattr(exists_task,key,value)
        db.add(exists_task)
        db.commit()
        db.refresh(exists_task)
        return "Task Edited"
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,detail="Server Error")
    

@router.get("/all_task")
def display_all_task(current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        exists_task=db.query(Todo_Modal).filter(Todo_Modal.list_user_email==current_user,Todo_Modal.isCompleted==False).all()
        if not exists_task:
            raise HTTPException(status_code=404,detail="Task NOT Found")
        return exists_task
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,detail="Server Error")
    

@router.get("/completed_task")
def display_all_task(current_user=Depends(get_user),db:Session=Depends(get_db)):
    try:
        exists_task=db.query(Todo_Modal).filter(Todo_Modal.list_user_email==current_user,Todo_Modal.isCompleted==True).all()
        if not exists_task:
            raise HTTPException(status_code=404,detail="Task NOT Found")
        return exists_task
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500,detail="Server Error")


