import sys
import os

# Ensure the backend root is on the Python path so `app.*` imports resolve
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from mangum import Mangum
from app.main import app

# Mangum wraps the ASGI app so Vercel's Lambda-style runtime can invoke it.
handler = Mangum(app, lifespan="off")
