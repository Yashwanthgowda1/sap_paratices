import  logging
from  datetime import  datetime
import  os


def  start_logging(log_dir='logs', file_name="api_testing"):
    '''
    this function help to collect the realtime logs to collect the data

    :param log_dir:  create the dir for logging

    :return:  return all the level of logger  [DEBUG, INFO, WARNING, ERROR, CRITICAL ]
    '''

    if not os.path.exists(log_dir):
        os.makedirs(log_dir)

    #genrate the file name
    file_path=os.path.join(log_dir,f"{file_name} {datetime.now().strftime("%d-%m-%Y, %H-%M-%S")}.log")

#     creating the logger
    logger=logging.getLogger(file_name)
    logger.setLevel(logging.DEBUG)

    # avoid creating the function multipal times
    if not logger.handlers:
        # write the logs to file also handel is uded to write the thing into logging
        file_Handler=logging.FileHandler(file_path)
        file_Handler.setLevel(logging.DEBUG)

        console_header=logging.StreamHandler()    #print into the console
        console_header.setLevel(logging.INFO)

#         which formate the log want
        formatter = logging.Formatter('%(asctime)s - %(levelname)s - %(funcName)s - %(lineno)d - %(message)s -the filename is :%(filename)s')
        file_Handler.setFormatter(formatter)
        console_header.setFormatter(formatter)

#         add the thing to rhe logger
        logger.addHandler(file_Handler)
        logger.addHandler(console_header)

    return  logger



