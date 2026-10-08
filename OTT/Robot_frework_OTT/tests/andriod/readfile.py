with open(r"C:\python_study\OTT\Robot_frework_OTT\requirements.txt", 'r+') as f:
    print("=== Original File Content ===")
    print(f.read())       # Reads everything → pointer at end
    
    f.write("\nThe new line is adding from the last\n")
    
    f.seek(0)             # Move pointer back to start
    print("=== Updated File Content ===")
    print(f.read())       # Reads again from beginning
