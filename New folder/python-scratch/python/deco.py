def run_three_times(func):

    def wrapper(device_1, jsonname, *args, **kwargs):
        final_output = 0
        print("fisrt start herer")

        for i in range(3):
            print(f"\nRun number: {i + 1}")
            final_output += func(device_1, jsonname, *args, **kwargs)

        return final_output

    return wrapper


def startlogcat(func):

    def wrapper_logcat(device_1, jsonname, *args, **kwargs):
        print(f"Collecting log details for device: {device_1}")
        print("logcat is collected")
        print("Logs saved to logcat.txt simulated")

        out += func(device_1, jsonname, *args, **kwargs)
        return out

    return wrapper_logcat


def clearcache(func):

    def wrapper_cache(device_1, jsonname, *args, **kwargs):
        print(f"Clearing cache on device: {device_1}")
        return func(device_1, jsonname, *args, **kwargs)

    return wrapper_cache


@run_three_times
@startlogcat
@clearcache
def wait_element(device_1, jsonname):
    print(f"Device in state: {device_1}")
    print(f"Using xpath json: {jsonname}")
    return 10 + 20


result = wait_element("device123", "xpath.json")
print("\nFinal Result:", result)


# file reading all methods

# with open("confi.json", "w+") as f:
    # f.writelines("amma how are you")  // remove exiting start from scartchh
    # f.write("amma how are you")   // only write existing data after