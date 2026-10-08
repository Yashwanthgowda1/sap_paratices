from mcp.server.fastmcp import FastMCP
# tool name srever name 
mcp=FastMCP("math")


@mcp.tool()
def add(a: int, b: int)-> int:
    " add the two number"
    return a+b
@mcp.tool()
def sub(a: int, b: int)-> int:
    " sub the two number"
    return a-b
@mcp.tool()
def multipal(a: int, b: int)-> int:
    " multipal the two number"
    return a*b



# if intrvre some time ask to expalin run the mcp


''''
it tell srevre to standerd input out put srever to recive and responce to tool funcion call
'''

# bacially run the srer at cmd and hit get answer in cmd and clint will read the responce in cmd it slef
# ex: working in locally at test the inputout in clints

if __name__ == "__main__":
    mcp.run(transport="stdio")