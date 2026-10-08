import  datetime
def verifying_current_date_before_select(need_to_select_minium):
    string=str(datetime.date.today())
    returning_values=string.split('-')[-1]
    if returning_values>=str(need_to_select_minium):
        raise AssertionError(f"select the date need to book and current datae is {string}")
    return  need_to_select_minium

