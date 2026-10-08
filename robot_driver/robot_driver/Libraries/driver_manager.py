from Libraries.AccountSetup import AccountSetup
from Libraries.initiate_driver import config


class DriverManager:
    @staticmethod
    def initiate_driver(device):
        device_name = device.split(":")[0]
        print(f"{device_name}: Initiating a Chrome webdriver")

        ac = AccountSetup.getInstance()

        if ac.device_store.has_alias(device_name):
            ac.teardown_device_driver(device_name)
            # Suggest this instead: raise AssertionError(f"{device_name}: Already has a driver")

        ac.setup_device_driver(device, config)

        print(f"{device_name}: WebDriver initiated successfully.")
        return ac.device_store.get(device_name)

    @staticmethod
    def get_driver(device_name):
        return AccountSetup.getInstance().device_store.get(device_name)

    @staticmethod
    def quit_driver(device_name):
        if AccountSetup.getInstance().device_store.has_alias(device_name):
            AccountSetup.getInstance().teardown_device_driver(device_name)
            print(f"{device_name} WebDriver closed successfully.")
        else:
            print(f"{device_name} No WebDriver to close.")


# Create an instance of DriverManager
driver_manager_instance = DriverManager()
