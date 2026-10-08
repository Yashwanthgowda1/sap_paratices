def csv_safe_string(s, replace_with="[ACOMMA]"):
    # Ensure the string specified does not contain any commas
    if s:
        s = str(s).replace(",", replace_with)
    else:
        s = ""
    return s
