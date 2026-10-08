import  os
from  dotenv import load_dotenv, dotenv_values
import  requests
from  pathlib import  Path
from  logger import start_logging



class Auth:
    BASE_DIR = Path(__file__).resolve().parent.parent  # go up one folder if script in subfolder
    env_path = BASE_DIR / ".env"

    logger=start_logging()
    load_dotenv(dotenv_path=env_path, override=True)     #override=True forces load_dotenv to overwrite any existing system environment variable.
    username = os.getenv('USERNAME')
    password = os.getenv('PASSWORD')
    base_url = os.getenv('BASE_URL')

    @classmethod
    def barrer_token_genrate(cls):
        ''''
        need topass the data in the form dict or json
        '''
        payload={"username":cls.username, "password":cls.password}
        cls.logger.info(f"collect the payload")
        _response =requests.post(f"{cls.base_url}/auth", json=payload)
        data = _response.json() if _response.content else {}
        cls.logger.info(f"sent the payload and genrate the response")

#         try:
# #             check the token is valid
#             response=requests.get(f"{self.base_url}/ping")
#             self.logger.info("start to ping")
#             if response.status_code == 201:
#                 self.logger.info("ping sceufully")
#         except requests.exceptions as e:
#             self.logger.error(f"the error of ping is  {e}")
        return  data


if __name__=="__main__":
    a1=Auth()
    print(a1.username)
    responce=a1.barrer_token_genrate()
    print("the token body", responce.get("token"))




