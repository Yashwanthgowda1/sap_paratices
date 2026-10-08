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