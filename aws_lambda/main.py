import json
import os

import boto3
import requests

URL: str = 'https://api.punkapi.com/v2/beers/random'


def get_record_from_api(url: str):
    try:
        response = requests.get(url)
        return response.json()[0]
    except Exception as err:
        print('An error occurred during the request. Error: ', err)
        raise err


def send_message_to_ks(msg: str, stream_name: str):
    client = boto3.client('kinesis')
    return client.put_record(
        Data=bytes(msg, 'utf-8'),
        PartitionKey='0',
        StreamName=stream_name
    )


def lambda_handler(event, context):
    print('Getting Records From Api')
    record = get_record_from_api(URL)
    print('Ingesting data on Kinesis Firestream')
    return send_message_to_ks(msg=json.dumps(record, ensure_ascii=False),
                              stream_name=os.environ['KINESIS_STREAM_NAME'])
