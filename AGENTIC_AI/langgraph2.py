from typing_extensions import TypedDict
from IPython.display import Image, display
from langgraph.graph import StateGraph, START, END
import random


## when ever my graph is exicuted it return in form schema dict 
### state
### first deine the state of the graph , the state schema srever as the input schema for all the nodes and edges in the graph



# --- define state schema ---
class State(TypedDict):
    graph_info: str

# --- define node functions ---
def state_play(state: State):
    print("state_play node is called")
    return {"graph_info": state["graph_info"] + " -> planning to play"}

def cricket(state: State):
    print("cricket node is called")
    return {"graph_info": state["graph_info"] + " -> playing cricket"}

def basketball(state: State):
    print("basketball node is called")
    return {"graph_info": state["graph_info"] + " -> playing basketball"}

# --- function to decide randomly which node to go next ---
def random_return_whichone(state: State):
    return "cricket" if random.random() > 0.5 else "basketball"

# --- create graph ---
graph = StateGraph(State)

# --- add nodes ---
graph.add_node("state_play", state_play)
graph.add_node("cricket", cricket)
graph.add_node("basketball", basketball)

# --- add edges ---
graph.add_edge(START, "state_play")
graph.add_conditional_edges("state_play", random_return_whichone)
graph.add_edge("cricket", END)
graph.add_edge("basketball", END)

# --- compile & display graph ---
graph_builder = graph.compile()
# display(Image(graph_builder.get_graph().draw_mermaid_png(max_retries=5, retry_delay=2.0)))
# above one is server down or get cahning



# from langchain_core.runnables.graph_mermaid import MermaidDrawMethod
# from IPython.display import Image, display

# img_bytes = graph_builder.get_graph().draw_mermaid_png(
#     draw_method=MermaidDrawMethod.PYPPETEER
# )
# display(Image(img_bytes))



graph_builder.invoke({'graph_info': "my name is yash"})