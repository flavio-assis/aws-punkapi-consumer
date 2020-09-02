import json
import os

import boto3
import requests

URL = 'https://api.punkapi.com/v2/beers/random'


def get_record_from_api(url):
    try:
        response = requests.get(url)
        return response.json()
    except Exception as err:
        print('An error occurred during the request. Error: ', err)
        raise err


def send_message_to_ks(msg):
    client = boto3.client('kinesis')
    return client.put_records(
        Records=[
            {
                'Data': msg,
                'PartitionKey': '1'
            }],
        StreamName=os.environ['KINESIS_STREAM_NAME']
    )


def lambda_handler(event, context):
    print('Getting Records From Api')
    record = get_record_from_api(URL)

    print('Ingesting data on Kinesis Firestream')
    return send_message_to_ks(json.dumps(record[0], ensure_ascii=False))
