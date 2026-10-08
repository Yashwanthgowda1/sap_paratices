from session import get_session


from Library_utility.logger import start_logging

logger = start_logging("create_utility")

def create_booking(url=None, booking_data=None):
    session = get_session()
    logger.info("Sending POST request")
    response = session.post(url, json=booking_data)
    return response
