from boto3 import client
import psutil

def check_ec2_instance_type(instance_id, expected_instance_type):
    client("ec2").describe_intances(InstanceIds=[instance_id])
    
    
