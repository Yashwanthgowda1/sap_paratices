import os
import asyncio
from dotenv import load_dotenv
from langchain_groq import ChatGroq
from langchain.schema import HumanMessage
from langgraph.prebuilt import create_react_agent
from langchain_mcp_adapters.client import MultiServerMCPClient

# Load environment variables
load_dotenv()
os.environ["GROQ_API_KEY"] = os.getenv("GROQ_API_KEY")

# Initialize LLM
llm = ChatGroq(model="llama3-8b-8192", api_key=os.getenv("GROQ_API_KEY"))

async def main():
    # Initialize MCP client
    client = MultiServerMCPClient()

    # Add servers individually
    client.add_server(
        name="math",
        command="python",
        args=["mcp_mathservermcp2.py"],
        transport="stdio"
    )
    client.add_server(
        name="wheather",
        url="http://127.0.0.1:8000",
        transport="streamable-http"
    )

    # ✅ Await get_tools because it's async👍😂💕
    tools = await client.get_tools()

    # Create LangGraph React agent
    clint_agent = create_react_agent(llm, tools)

    # Send query
    response = await clint_agent({"messages": [HumanMessage(content="What is 6 + 5?")]})

    # Print the result
    print("Math response:", response["messages"][-1].content)

# Run async main
if __name__ == "__main__":
    asyncio.run(main())
