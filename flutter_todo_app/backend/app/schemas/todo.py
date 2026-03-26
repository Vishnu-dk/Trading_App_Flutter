from pydantic import BaseModel
from typing import Optional

class TodoDelete(BaseModel):
    title:str

class TodoAdd(TodoDelete):
    description:str|None=None

class TodoEdit(TodoAdd):
    oldtitle:Optional[str]
    isCompleted:Optional[bool]=False

