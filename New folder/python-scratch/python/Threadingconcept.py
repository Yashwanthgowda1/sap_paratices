# Concept	    Purpose
# Lock	        Prevent race condition
# RLock	        Reentrant locking
# Deadlock	    Circular waiting
# GIL	        Only one thread executes Python bytecode
# ThreadPoolExecutor	Manage thread pool
# Daemon	    Background thread
# Queue	        Thread-safe communication

# using the normal lock() get the dead lock the thread is aquire the same lock   normal one lock occoure at a time
import threading
'''
import threading
lock=threading.Lock()

def worker():
    print("now it comes here but smae lock aquire")
    with lock:
        print("the worker lock enter")

def emplyee():
    with lock:
        worker()
t1=threading.Thread(target=emplyee) 
# t2=threading.Thread(target=emplyee)
t1.start()
# t2.start()
# t2.join()
t1.join()
'''

# this above proble reslove by Rlock
'''
import threading
lock=threading.RLock()
def worker():
    print("now it comes here but smae lock aquire")
    with lock:
        print("the worker lock enter")

def emplyee():
    with lock:
        worker()
t1=threading.Thread(target=emplyee) 
# t2=threading.Thread(target=emplyee)
t1.start()
# t2.start()
# t2.join()
t1.join()
      
'''

# demon thread when need to kill the main task and perform the background  like loging , logcollect mointering, clearchance
'''
import threading
import time

def emplyee():
        while True:
            print("the main started")
            time.sleep(1)
t1=threading.Thread(target=emplyee, daemon=True) 

t1.start()
time.sleep(3)
print("the main thread is killed")

'''





#condition THreading is used to synchronize threads based on certain conditions.
'''
notify() wakes up one waiting thread, while notify_all() wakes up all waiting threads.
wait() releases the lock and blocks until another thread calls notify() or notify_all().
acquire() and release() are used to manually manage locks, but using with statement is recommended for better readability and safety.


We normally don’t use acquire() and release() manually 
 because the with condition: block manages locking automatically.
 wait() temporarily releases and reacquires the lock, while notify() 
 only signals waiting threads.'''

import threading
'''
listvalues = []
condition = threading.Condition()

def consumer():
    print("Consumer started")
    with condition:
        while not listvalues:
            print("Consumer waiting for order...")
            condition.wait()
        print("Consumer processing:", listvalues.pop())

def producer():
    print("Producer adding order...")
    with condition:
        listvalues.append("order1")
        print("Producer added order")
        condition.notify()

threading.Thread(target=consumer).start()
threading.Thread(target=producer).start()



from concurrent.futures import ThreadPoolExecutor
import time



def task(n):
    print(f"Task {n} started")
    time.sleep(1)
    print(f"task {n} file readed")
filr=["file1", "file2", "file3", "file4", "file5"]    

with ThreadPoolExecutor(max_workers=3)   as executor:
    results=executor.map(task, filr)
    '''




from concurrent.futures import ThreadPoolExecutor
import time
import random

# Simulated shared message store
chat_room = []

def user_a_send_message():
    print("User A logging in...")
    time.sleep(1)

    message = "Hello Team!"
    print("User A sending message:", message)

    time.sleep(1)
    chat_room.append(message)

    print("User A message sent successfully")
    return "User A done"


def user_b_receive_message():
    print("User B logging in...")
    time.sleep(2)

    print("User B checking for messages...")

    # wait until message appears
    while not chat_room:
        time.sleep(0.5)

    received = chat_room[-1]
    print("User B received message:", received)

    assert received == "Hello Team!"
    print("User B validated message successfully")
    return "User B done"


def user_c_join_meeting():
    print("User C logging in...")
    time.sleep(1.5)

    print("User C joining meeting...")
    time.sleep(1)

    print("User C joined meeting successfully")
    return "User C done"


# Thread Pool Execution
with ThreadPoolExecutor(max_workers=3) as executor:
    futures = [
        executor.submit(user_a_send_message),
        executor.submit(user_b_receive_message),
        executor.submit(user_c_join_meeting)
    ]

    for future in futures:
        print(future.result())

print("Multi-user simulation completed")




    