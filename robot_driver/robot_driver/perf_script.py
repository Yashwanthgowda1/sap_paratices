import os
import re
import copy
import pandas as pdn
import openpyxl.styles
from openpyxl.styles import Border, Side, Alignment, NamedStyle
from Libraries.Selectors import load_json_file


def colour_cells(cell, colour):
    fill_colour = openpyxl.styles.fills.PatternFill(fgColor=colour, fill_type="solid")
    cell.fill = fill_colour


def set_cell_colour(sheet):
    for key, *values in sheet.iter_rows(min_row=11, max_row=sheet.max_row, max_col=7):
        if key.value in title_list:
            std_ref_value = benchmark_list[title_list.index(key.value)]
        if values[-1].value != "NA":
            median_value = float(values[-1].value)
            if std_ref_value == 0.0:
                colour_cells(values[-1], "66CCCC")
            elif median_value < std_ref_value:
                colour_cells(values[-1], "009900")
            elif median_value > std_ref_value and median_value <= (std_ref_value * 1.2):
                colour_cells(values[-1], "FFBF00")
            elif median_value > (std_ref_value * 1.2):
                colour_cells(values[-1], "CC0000")


def set_column_width(sheet):
    for sheet_row in sheet.rows:
        for cell in sheet_row:
            alignment = copy.copy(cell.alignment)
            alignment.wrapText = True
            cell.alignment = alignment
    for column_number, sheet_column in enumerate(sheet.columns):
        for cell in sheet_column:
            if column_number == 0:
                sheet.column_dimensions[cell.column_letter].width = 40
            else:
                sheet.column_dimensions[cell.column_letter].width = 15


def apply_style_to_table(sheet, style, min_index, max_index, max_row=None):
    if max_index == 2:
        for key, *values in sheet.iter_rows(max_row=min_index, max_col=max_index):
            key.style = style
            if key.value is None:
                key.value = "Device Specifications"
                colour_cells(key, "999999")
            for value in values:
                value.style = style
    elif max_row is not None:
        for key, *values in sheet.iter_rows(min_row=min_index, max_row=max_row, max_col=max_index):
            values = values[7:9]
            for cell in values:
                if cell.value is None:
                    cell.style = style
                    cell.value = "Table Legend"
                    colour_cells(cell, "999999")
                    break
                cell.style = style
                if cell.value == "blue":
                    colour_cells(cell, "66CCCC")
                elif cell.value == "green":
                    colour_cells(cell, "009900")
                elif cell.value == "amber":
                    colour_cells(cell, "FFBF00")
                elif cell.value == "red":
                    colour_cells(cell, "CC0000")
                if cell.value in ["blue", "green", "amber", "red"]:
                    cell.value = ""
    else:
        for key, *values in sheet.iter_rows(min_row=min_index, max_col=max_index):
            if key.value == "Scenario":
                colour_cells(key, "999999")
                for value in values:
                    value.style = style
                    colour_cells(value, "999999")
            else:
                for value in values:
                    value.style = style


def set_border_and_text_alignment(sheet, table_type="data_table"):
    if table_type.lower() not in ["data_table", "legend_table"]:
        raise AssertionError(f"Invalid value for table_type: {table_type}")
    thin_border = Side(style="thin")
    thin_border_style = Border(left=thin_border, right=thin_border, top=thin_border, bottom=thin_border)
    centre_alignment = Alignment(horizontal="center", vertical="center", wrap_text=True)
    common_style = NamedStyle(name="specified_style")
    common_style.alignment = centre_alignment
    common_style.border = thin_border_style
    if table_type.lower() == "legend_table":
        sheet.merge_cells("I12:J12")
        try:
            apply_style_to_table(sheet, common_style, 12, 10, 16)
        except ValueError:
            apply_style_to_table(sheet, "specified_style", 12, 10, 16)
        return
    sheet.merge_cells("A1:B1")
    try:
        apply_style_to_table(sheet, common_style, 6, 2)
        apply_style_to_table(sheet, common_style, 10, 7)
    except ValueError:
        apply_style_to_table(sheet, "specified_style", 6, 2)
        apply_style_to_table(sheet, "specified_style", 10, 7)


def create_table_legend():
    df2 = pdn.DataFrame(columns=["Table Legend"], index=["blue", "green", "amber", "red"])
    legend_value_list = [
        "Value doesn't have any std. reference value",
        "Value less than std. reference value",
        "Value not more than 20% of std. reference value",
        "Value more than 20% of std. benchmark value",
    ]
    i = 0
    for index, row in df2.iterrows():
        row["Table Legend"] = legend_value_list[i]
        i = i + 1
    return df2


def format_legend(sheet):
    set_border_and_text_alignment(sheet, table_type="legend_table")


perf_dict = load_json_file("perf_mapping.json")
input_text = [
    "Path of the perf logs file",
    "Device Name",
    "Device Firmware",
    "Teams App version",
    "Company Portal version/ ASOP",
    "Admin Agent version",
]
user_input = []
index_list = []
print(f"\nPlease enter the required details to generate performance report\n")
print(
    f"Choose an option based on the device category used for performance testing\n"
    f"1. Teams Phones - Desk Phones\n"
    f"2. Teams Phones - Conference Phones\n"
    f"3. Teams Phones - Low Cost Phones (LCP)\n"
    f"4. Teams Rooms - Microsoft Teams Room Android (MTRA)\n"
)
category_option = input(f"Select 1, 2, 3 or 4 : ")
while True:
    if category_option not in ["1", "2", "3", "4"]:
        category_option = input(f"Please enter any valid option as per the above provided choices : ")
        continue
    break
for input_item in range(len(input_text)):
    user_input_value = input(f"{input_text[input_item]} : ")
    while user_input_value in ["", " ", "\t"]:
        user_input_value = input(f"{input_text[input_item]} : ")
    user_input.append(user_input_value)
if not os.path.exists(user_input[0]):
    raise AssertionError(f"Invalid logs file path input: {user_input[0]}")
os.chdir(user_input[0])
file_list = os.listdir()
file_list.sort()
title_list = []
benchmark_list = []
std_ref_value_list = []
scenario_list = list(perf_dict["scenario"].keys())
for scenario in scenario_list:
    if category_option in perf_dict["scenario"][scenario]["category"]:
        if isinstance(perf_dict["scenario"][scenario]["title"], list):
            for title in perf_dict["scenario"][scenario]["title"]:
                title_list.append(title)
        else:
            title_list.append(perf_dict["scenario"][scenario]["title"])
        if isinstance(perf_dict["scenario"][scenario]["benchmark"], list):
            for benchmark_value in perf_dict["scenario"][scenario]["benchmark"]:
                benchmark_list.append(float(benchmark_value))
        else:
            benchmark_list.append(float(perf_dict["scenario"][scenario]["benchmark"]))

df = pdn.DataFrame(columns=["1", "2", "3", "4", "5"], index=title_list)
df = df.rename_axis("Scenario")
df1 = pdn.DataFrame(
    columns=["Device Specifications"], index=["Device", "Firmware", "Teams App", "Company Portal", "Admin Agent"]
)
i = 1
value_flag = False
for index, row in df1.iterrows():
    row["Device Specifications"] = str(user_input[i])
    i += 1
match_pattern = r"\d+-\d+T\d+:\d+:\d+"
for file in file_list:
    file_key = file.split("iteration")[0].split("-")[1].lstrip("_")
    col_key = file.split("iteration")[1].rstrip(".txt")
    search_text = perf_dict["scenario"][file_key]["search_text"]
    title_text = perf_dict["scenario"][file_key]["title"]
    if not isinstance(search_text, list):
        search_text = search_text.split(",")
    if not isinstance(title_text, list):
        title_text = title_text.split(",")
    with open(file, "r", encoding="utf-8") as f:
        read_lines = f.readlines()
        for marker in search_text:
            for i in range(len(read_lines)):
                if marker in read_lines[i]:
                    row_index = search_text.index(marker)
                    row_key = title_text[row_index]
                    if re.search(match_pattern, read_lines[i]):
                        search_pattern = re.search(match_pattern, read_lines[i]).group().replace("T", " ")
                        read_lines[i] = re.sub(match_pattern, search_pattern, read_lines[i])
                    if file_key == "Start_meet_now_meeting":
                        if "meetNowSetup" in read_lines[i]:
                            if read_lines[i].split()[13].isdigit():
                                value1 = int(read_lines[i].split()[13]) / 1000
                                value_flag = True
                        if "connected" in read_lines[i] and value_flag:
                            if read_lines[i].split()[12].isdigit():
                                value2 = int(read_lines[i].split()[12]) / 1000
                                try:
                                    df.loc[row_key][col_key] = value2 - value1
                                except KeyError as e:
                                    print(
                                        f"The scenario: '{file_key}' is not supported for the selected device category. Hence contuning"
                                    )
                                break
                        continue
                    elif "STOP" in read_lines[i]:
                        if read_lines[i].split()[12].isdigit():
                            try:
                                df.loc[row_key, col_key] = int(read_lines[i].split()[12]) / 1000
                            except KeyError as e:
                                print(
                                    f"The scenario: '{file_key}' is not supported for the selected device category. Hence contuning"
                                )
                            break
df["Median"] = df.median(axis=1)
df.round(3)
for col in df.columns:
    df[col] = df[col].fillna("NA")
df.rename(
    columns={
        "1": "Time taken in seconds (Iteration1)",
        "2": "Time taken in seconds (Iteration2)",
        "3": "Time taken in seconds (Iteration3)",
        "4": "Time taken in seconds (Iteration4)",
        "5": "Time taken in seconds (Iteration5)",
    },
    inplace=True,
)
legend = create_table_legend()
writer = pdn.ExcelWriter("Perf_DataFile.xlsx", engine="xlsxwriter")
df1.to_excel(writer, sheet_name="Perf_data", startrow=0, startcol=0)
df.to_excel(writer, sheet_name="Perf_data", startrow=9, startcol=0)
legend.to_excel(writer, sheet_name="Perf_data", startrow=11, startcol=8)
writer.close()

# Format the sheet - Set coulmn width, alignment, borders and also, colour the median values based on std. reference values
workbook = openpyxl.load_workbook("Perf_DataFile.xlsx")
worksheet = workbook.active
set_column_width(worksheet)
set_border_and_text_alignment(worksheet)
set_cell_colour(worksheet)
format_legend(worksheet)
workbook.save("Perf_DataFile.xlsx")
workbook.close()

print(f"\nThe performance report has been generated and stored in path:\n{user_input[0]}")
