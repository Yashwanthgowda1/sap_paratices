from fastapi import FastAPI, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm

from Api_mock.auth import (
    login, get_current_user, create_token, require_role,
    registration_new_user, create_agent_token, get_current_agent,
)
from Api_mock.Basemodel import CustomerCreate, CustomerResponse,UserResponse, UserCreate
from typing import List
import Api_mock.Basemodel
import sqlite3
from fastapi import Depends, HTTPException, status

DB_PATH = "Sqllite/insurance.db"

app = FastAPI(title="Insurance Mock API")


def _get_conn():
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    return conn


# ── Auth ──────────────────────────────────────────────────────────────────────

@app.post("/login")
def login_route(form_data: OAuth2PasswordRequestForm = Depends()):
    return login(form_data)


@app.get("/auth/me")
def me(current_user: dict = Depends(get_current_user)):
    return current_user


@app.post("/auth/token")
def generate_token(role: str, user=Depends(get_current_user)):
    token = create_token(user["user_id"], role)
    return {"access_token": token, "token_type": "bearer"}


# ── Customers ─────────────────────────────────────────────────────────────────

# GET all customers — Admin and Agent only
# @app.get("/customers", response_model=List[CustomerResponse])
# def get_all_customers(_=Depends(require_role("Admin", "Agent"))):
#     conn = _get_conn()
#     try:
#         rows = conn.execute("SELECT * FROM customers").fetchall()
#         return [dict(r) for r in rows]
#     finally:
#         conn.close()




# GET one customer by ID
# Admin/Agent can view anyone, Customer can only view their own
@app.get("/customers/{customer_id}", response_model=CustomerResponse)
def get_customer(customer_id: int, user=Depends(get_current_user)):
    if user["role"] == "Customer":
        conn = _get_conn()
        try:
            row = conn.execute(
                "SELECT * FROM customers WHERE customer_id=?",
                (customer_id)
            ).fetchone()
        finally:
            conn.close()
        if row is None:
            raise HTTPException(status_code=403, detail="Access denied")
        return dict(row)

    conn = _get_conn()
    try:
        row = conn.execute(
            "SELECT * FROM customers WHERE customer_id=?", (customer_id,)
        ).fetchone()
    finally:
        conn.close()
    if row is None:
        raise HTTPException(status_code=404, detail="Customer not found")
    return dict(row)


# CREATE customer — Admin only
@app.post("/customers", response_model=CustomerResponse, status_code=201)
def create_customer(data: CustomerCreate, _=Depends(require_role("Admin"))):
    conn = _get_conn()
    try:
        cursor = conn.execute(
            """INSERT INTO customers
               (user_id, first_name, last_name, dob, gender, email,
                phone, address, city, state, pincode, pan_number, aadhar_number)
               VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)""",
            (data.user_id, data.first_name, data.last_name, str(data.dob),
             data.gender, data.email, data.phone, data.address,
             data.city, data.state, data.pincode, data.pan_number, data.aadhar_number)
        )
        conn.commit()
        row = conn.execute(
            "SELECT * FROM customers WHERE customer_id=?", (cursor.lastrowid,)
        ).fetchone()
        return dict(row)
    finally:
        conn.close()


# UPDATE customer — Admin only
@app.put("/customers/{customer_id}", response_model=CustomerResponse)
def update_customer(customer_id: int, data: CustomerCreate, _=Depends(require_role("Admin"))):
    conn = _get_conn()
    try:
        conn.execute(
            """UPDATE customers SET
               first_name=?, last_name=?, dob=?, gender=?, email=?,
               phone=?, address=?, city=?, state=?, pincode=?,
               pan_number=?, aadhar_number=?
               WHERE customer_id=?""",
            (data.first_name, data.last_name, str(data.dob), data.gender,
             data.email, data.phone, data.address, data.city, data.state,
             data.pincode, data.pan_number, data.aadhar_number, customer_id)
        )
        conn.commit()
        row = conn.execute(
            "SELECT * FROM customers WHERE customer_id=?", (customer_id,)
        ).fetchone()
    finally:
        conn.close()
    if row is None:
        raise HTTPException(status_code=404, detail="Customer not found")
    return dict(row)


# DELETE customer — Admin only
@app.delete("/customers/{customer_id}", status_code=204)
def delete_customer(customer_id: int, _=Depends(require_role("Admin"))):
    conn = _get_conn()
    try:
        affected = conn.execute(
            "DELETE FROM customers WHERE customer_id=?", (customer_id,)
        ).rowcount
        conn.commit()
    finally:
        conn.close()
    if affected == 0:
        raise HTTPException(status_code=404, detail="Customer not found")



@app.post("/registaion", response_model=UserResponse)
def registration_customer(registaion:UserCreate):
    result = registration_new_user(dict(registaion))
    # ** unpacks dict into keyword args
    return UserResponse(**result)
    

            
         
 #============== brach craetion +=============
@app.post("/branch", response_model=Api_mock.Basemodel.BranchResponse, status_code=200)
def create_Branch(data: Api_mock.Basemodel.BranchCreate , _=Depends(require_role("Admin"))):
    # think like this content presnet inside the services callin form that
    conn=_get_conn()
    cursor=conn.cursor()
    try:
        values=cursor.execute(("""INSERT INTO branches (branch_name, region, address, contact_phone, contact_email) VALUES (?,?,?,?,?)"""), (data.branch_name, data.region, data.address, data.contact_phone, data.contact_email))
        row_branch_id=cursor.lastrowid
        
        if(row_branch_id==None):
            raise HTTPException(
                status_code=status.HTTP_422_INTERNAL_SERVER_ERROR  ,
                detail="Brach data is not successed"

            )
        conn.commit()
        row=cursor.execute("SELECT * FROM branches WHERE branch_id=?", (row_branch_id,)).fetchone()  
        
        return Api_mock.Basemodel.BranchResponse(**dict(row))
        



    finally:
       
        conn.close()    

# 422 -> Validation Error
@app.put("/branchupdate/{branch_id}", response_model=Api_mock.Basemodel.BranchResponse)
def update_branch(branch_id , data:Api_mock.Basemodel.BranchCreate, user=Depends(require_role("Admin"))):
    conn=_get_conn()
    cursor=conn.cursor()
    try:
        cursor.execute('''
        UPDATE branches
        SET
            branch_name = ?,
            region = ?,
            address = ?,
            contact_phone = ?,
            contact_email = ?
        WHERE branch_id = ?
        ''', (data.branch_name, data.region, data.address, data.contact_phone, 
              data.contact_email, branch_id))
        # update_last_details=cursor.lastrowid 
        # if(update_last_details==None):  
        #     raise HTTPException(
        #                     status_code=status.HTTP_422_INTERNAL_SERVER_ERROR  ,
        #                     detail="Brach data is not successed"
            

        #      
        # 
        #            )  

        print("Received branch_id:", branch_id)
        # if cursor.rowcount == 0:
        #     raise HTTPException(
        #     status_code=404,
        #     detail="Branch not found"
        # )
    
        conn.commit()
        all_rows = cursor.execute(
            "SELECT branch_id, branch_name FROM branches"
        ).fetchall()

        print("All branches:", all_rows)

        print("Received branch_id:", branch_id)

        row=cursor.execute("SELECT * FROM branches WHERE branch_id=?", (branch_id,)).fetchone()  
                
        return Api_mock.Basemodel.BranchResponse(**dict(row))

    finally:
        conn.close()     


@app.post(
    "/agent",
    response_model=Api_mock.Basemodel.AgentTokenResponse)
# )but this still runs and blocks if not Admin
def create_agent(data: Api_mock.Basemodel.AgentCreate, _=Depends(require_role("Admin"))):
    conn = _get_conn()
    cursor = conn.cursor()
    try:
        
        if data.user_id is None:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST,     
                detail="Create the account first",

            )
        all_ccount_ids=cursor.execute(
            "SELECT user_id FROM users Where user_id=?", (data.user_id)
        ).fetchone()
        if all_ccount_ids is None:
            raise HTTPException(
                            status_code=status.HTTP_400_BAD_REQUEST,     
                            detail="Create the account first",
            
                        )


        cursor.execute(
            """
            INSERT INTO agents
            (user_id, first_name, last_name, email, phone,
             license_no, branch_id, commission_rate, joined_date)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
            """,
            (
                data.user_id, data.first_name, data.last_name,
                data.email, data.phone, data.license_no,
                data.branch_id, data.commission_rate, data.joined_date,
            )
        )
        new_agent_id = cursor.lastrowid
        conn.commit()
        row = cursor.execute(
            "SELECT * FROM agents WHERE agent_id = ?", (new_agent_id,)
        ).fetchone()

        token = create_agent_token(new_agent_id)
        return Api_mock.Basemodel.AgentTokenResponse(
            agent=Api_mock.Basemodel.AgentResponse(**dict(row)),
            access_token=token,
        )
    finally:
        conn.close()


@app.get(
    "/agent/{agent_id}",
    response_model=Api_mock.Basemodel.AgentResponse
)
def get_agent(agent_id: int, current_agent: dict = Depends(get_current_agent)):
    # token must have been issued for this specific agent_id
    if current_agent["agent_id"] != agent_id:
        raise HTTPException(status_code=403, detail="Token does not belong to this agent")

    conn = _get_conn()
    try:
        row = conn.execute(
            "SELECT * FROM agents WHERE agent_id = ?", (agent_id,)
        ).fetchone()
        if row is None:
            raise HTTPException(status_code=404, detail="Agent not found")
        return Api_mock.Basemodel.AgentResponse(**dict(row))
    finally:
        conn.close()


@app.put(
    "/agent/{agent_id}",
    response_model=Api_mock.Basemodel.AgentResponse
)
def update_agent(
    agent_id: int,
    data: Api_mock.Basemodel.AgentUpdate,
    current_agent: dict = Depends(get_current_agent),
):
    if current_agent["agent_id"] != agent_id:
        raise HTTPException(status_code=403, detail="Token does not belong to this agent")

    conn = _get_conn()
    cursor = conn.cursor()
    try:
        cursor.execute(
            """
            UPDATE agents
            SET first_name=?, last_name=?, email=?, phone=?,
                license_no=?, branch_id=?, commission_rate=?
            WHERE agent_id=?
            """,
            (
                data.first_name, data.last_name, data.email, data.phone,
                data.license_no, data.branch_id, data.commission_rate,
                agent_id,
            )
        )
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Agent not found")
        conn.commit()
        row = cursor.execute(
            "SELECT * FROM agents WHERE agent_id = ?", (agent_id,)
        ).fetchone()
        return Api_mock.Basemodel.AgentResponse(**dict(row))
    finally:
        conn.close()


@app.patch(
    "/agent/{agent_id}",
    response_model=Api_mock.Basemodel.AgentResponse
)
def partial_update_agent(
    agent_id: int,
    data: Api_mock.Basemodel.AgentPartialUpdate,
    current_agent: dict = Depends(get_current_agent),
):
    if current_agent["agent_id"] != agent_id:
        raise HTTPException(status_code=403, detail="Token does not belong to this agent")

    conn = _get_conn()
    cursor = conn.cursor()
    try:
        # build SET clause from only the fields that were sent ,  model_dump will give all playload which it is passed
        updates = {k: v for k, v in data.model_dump().items() if v is not None}
        if not updates:
            raise HTTPException(status_code=422, detail="No fields provided to update")

        set_clause = ", ".join(f"{col}=?" for col in updates)
        values = list(updates.values()) + [agent_id]
        cursor.execute(
            f"UPDATE agents SET {set_clause} WHERE agent_id=?",values
            )
        if cursor.rowcount == 0:
            raise HTTPException(status_code=404, detail="Agent not found")
        conn.commit()
        row = cursor.execute(
            "SELECT * FROM agents WHERE agent_id = ?", (agent_id,)
        ).fetchone()
        return Api_mock.Basemodel.AgentResponse(**dict(row))
    finally:
        conn.close()