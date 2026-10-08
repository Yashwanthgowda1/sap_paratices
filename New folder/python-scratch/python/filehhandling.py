# from PyPDF2 import PdfReader
# content=PdfReader(r"C:\Users\C5403671\Downloads\d2854469-28751528-IOS-Al-Ameen-law-college (1).pdf")
# string= 'main contnet' 
# string1=[]
# with open("newpdftotxt.txt", 'w+', encoding="utf-8") as f:
#     f.write((string.center(50, "#"))+ "\n")
#     for pages in content.pages:
#         f.write(pages.extract_text())
#     f.seek(0)    
#     string1.extend(f.readlines())
 
# print(string1)


# read the json file
# load it i wll tak a object but loads will take a string
import json
with open ("confi.json", "r") as f:
    loads_data=f.read()
    jsonfile=json.loads(loads_data)
    # jsonfile=json.load(f)
# print(jsonfile)

# print(jsonfile["company"]["departments"][0]["employees"][0]["skills"]["programming"][1])


# print(jsonfile["company"]["departments"][1]["name"])
# company=jsonfile.get("company").get("location", {}).get("state")
import pickle
company=jsonfile.get("company").get("departments", [])[0].get("employees", [])[1].get("skills", {}).get("tools")
with open("storeversiongithub.pkl", "wb") as f:
    pickle.dump(company, f)
data=pickle.load(open("storeversiongithub.pkl", "rb"))
print(data.get("ci_cd"))