import os
import sqlite3
from datetime import datetime, timedelta

import dotenv
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt

dotenv.load_dotenv()

SECRET_KEY = os.getenv("SECRET_KEY", "fallback-dev-secret")
ALGORITHM  = "HS256"
DB_PATH    = "Sqllite/insurance.db"

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/login")


# ── helpers ───────────────────────────────────────────────────────────────────

def _get_connection():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row   # rows behave like dicts
    return conn


def create_token(user_id: int, role: str) -> str:
    payload = {
        "sub":  str(user_id),
        "role": role,
        "exp":  datetime.now() + timedelta(hours=1),
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


# ── login endpoint logi
# c ───────────────────────────────────────────────────────

def login(form_data: OAuth2PasswordRequestForm = Depends()):
    """
    Accepts username (treated as email) + password via form body.
    Returns a Bearer token on success.
    """
    conn   = _get_connection()
    cursor = conn.cursor()
    try:
        cursor.execute(
            "SELECT user_id, name, email, role, password_hash FROM users WHERE email = ?",
            (form_data.username,),
        )
        user = cursor.fetchone()
    finally:
        conn.close()

    if user is None or user["password_hash"] != form_data.password:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid email or password",
            headers={"WWW-Authenticate": "Bearer"},
        )

    token = create_token(user["user_id"], user["role"])
    return {
        "access_token": token,
        "token_type":   "bearer",
        "user_id":      user["user_id"],
        "role":         user["role"],
    }


# ── token verification (use as Depends in protected routes) ───────────────────

def get_current_user(token: str = Depends(oauth2_scheme)) -> dict:
    credentials_error = HTTPException(
        status_code=401,
        detail="Could not validate token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: str = payload.get("sub")
        role:    str = payload.get("role")
        if user_id is None:
            raise credentials_error
    except JWTError:
        raise credentials_error

    return {"user_id": int(user_id), "role": role}


# ── RBAC — role based access control ─────────────────────────────────────────

def require_role(*allowed_roles: str):
    """
    Usage:  Depends(require_role("admin"))
            Depends(require_role("admin", "agent"))
    """
    def check(current_user: dict = Depends(get_current_user)):
        if current_user["role"] not in allowed_roles:
            raise HTTPException(
                status_code=status.HTTP_403_FORBIDDEN,
                detail=f"Access denied. Required role: {list(allowed_roles)}",
            )
        return current_user
    return check


def create_agent_token(agent_id: int) -> str:
    payload = {
        "agent_id": agent_id,
        "exp": datetime.now() + timedelta(hours=1),
    }
    return jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)


def get_current_agent(token: str = Depends(oauth2_scheme)) -> dict:
    """Validates a token that was issued for a specific agent (contains agent_id)."""
    credentials_error = HTTPException(
        status_code=401,
        detail="Could not validate agent token",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        agent_id = payload.get("agent_id")
        if agent_id is None:
            raise credentials_error
    except JWTError:
        raise credentials_error
    return {"agent_id": agent_id}


def registration_new_user(details:dict):
    """
    registation as new user when user enter the username and password
    default take the role will clint and creat the account
    """
    email    = details.get("email")
    name     = details.get("name")
    password = details.get("password_hash")
    role     = details.get("role", "Customer") 
    conn=_get_connection()
    cursor = conn.cursor()
    try:

        cursor.execute("select user_id from users where email  = ? ", (email,))
        if cursor.fetchone():
            raise HTTPException(
                status_code=status.HTTP_409_CONFLICT,
                detail="Email already registered"
                
            )

        
        


      
            # seed the user details in db
        cursor.execute(
                        "INSERT INTO users (email, name, password_hash, role) values(?,?,?,?)",(
                                email, name, password, role)
                        )
        
        conn.commit()
        user_id = cursor.lastrowid
     
        row = cursor.execute(
        "SELECT * FROM users WHERE user_id = ?", (user_id,)
       ).fetchone()
                
        # user_id =cursor.lastrowid()
        print("\nSeed complete. Use email as username in /login.")    
        return dict(row)
    # 422 ->required thingsis wrong or misisng 
    # 409 conflit alredy eixst 
    finally:
        conn.close()




   



    
        

       

    



