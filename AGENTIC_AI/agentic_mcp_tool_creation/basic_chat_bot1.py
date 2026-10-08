from langgraph.graph import StateGraph, START, END
from typing_extensions import Annotated, TypedDict
from langgraph.graph.message import add_messages
from langchain.schema import HumanMessage
from langchain_groq import ChatGroq
import os
from dotenv import load_dotenv
from IPython.display import display, Markdown, Image

# ----------------------------
# 1️⃣ Load API key
# ----------------------------
load_dotenv()
API_KEY = os.getenv("GROQ_API_KEY")
os.environ["GROQ_API_KEY"] = API_KEY

# ----------------------------
# 2️⃣ Define State
# ----------------------------
class State(TypedDict):
    messages: Annotated[list, add_messages]

# ----------------------------
# 3️⃣ Initialize graph
# ----------------------------
graph_bulder = StateGraph(State)

# ----------------------------
# 4️⃣ Initialize LLM
# ----------------------------
llm = ChatGroq(model="llama3-8b-8192", api_key=API_KEY)

# ----------------------------
# 5️⃣ Define chatbot node
# ----------------------------
def chatbot(state: State):
    last_msg = state["messages"][-1]        # HumanMessage object
    user_text = last_msg.content            # access content
    ai_response = llm.invoke(user_text)     # get AI response
    return {"messages": [ai_response]}      # reducer expects key "messages"

# ----------------------------
# 6️⃣ Add node and edges (only once)
# ----------------------------
graph_bulder.add_node("chatbot_llm", chatbot)
graph_bulder.add_edge(START, "chatbot_llm")
graph_bulder.add_edge("chatbot_llm", END)

# ----------------------------
# 7️⃣ Compile the graph
# ----------------------------
graph_builder = graph_bulder.compile()

# ----------------------------
# 8️⃣ Optional: visualize graph (works in Jupyter)
# ----------------------------
try:
    img_bytes = graph_builder.get_graph().draw_mermaid_png(max_retries=3, retry_delay=1.0)
    display(Image(img_bytes))
except Exception:
    mermaid_code = graph_builder.get_mermaid()
    display(Markdown(f"```mermaid\n{mermaid_code}\n```"))

# ----------------------------
# 9️⃣ Invoke the graph
# ----------------------------
response = graph_builder.invoke(
    {"messages": [HumanMessage(content="Hi")]}  # pass as HumanMessage object
)

# ----------------------------
# 🔟 Print assistant reply safely
# ----------------------------
last_msg = response["messages"][-1]
# works for dict or HumanMessage object
content = getattr(last_msg, "content", None) or last_msg
print("AI RESPONSE:", content)
