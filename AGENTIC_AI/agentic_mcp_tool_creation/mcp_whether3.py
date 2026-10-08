from mcp.server.fastmcp import FastMCP


# tool name
mcp=FastMCP("wheather")
@mcp.tool()

async def whether(city: str)-> str:
    " get the wheather of city"
    return f" today is 30 deg in bengaluru"


if __name__ == "__main__":
    mcp.run(transport="streamable-http") 



#    ex: try to run ythe stdio in cmd look changes in classmethodcode m_whether.py
 # 