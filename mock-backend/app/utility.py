from fastapi import HTTPException
from typing import Optional, List, Dict, Any

def check_auth(authorization: Optional[str]):
    if authorization is None:
        return
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Invalid Authorization header")
