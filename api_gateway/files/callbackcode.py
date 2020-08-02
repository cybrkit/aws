import json
import os

def handler(event, context):
    response = {'statusCode': 200, 'body': 'Hello World'}
    response["headers"] = {'Content-Type': 'application/json', 'Access-Control-Allow-Origin': '*'}

    return response
