import boto3

ssm = boto3.client("ssm")

PARAM_NAME = "/counter/value"

def lambda_handler(event, context):
    # 1. Read current value
    response = ssm.get_parameter(Name=PARAM_NAME)
    current_value = int(response["Parameter"]["Value"])
    
    # 2. Increment
    new_value = current_value + 1
    
    # 3. Print the number
    print(f"Trigger Count: {new_value}")
    print("123456789")
    
    # 4. Save new value back to SSM
    ssm.put_parameter(
        Name=PARAM_NAME,
        Value=str(new_value),
        Overwrite=True
    )
    
    return {"count": new_value}





