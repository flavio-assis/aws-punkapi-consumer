import json
import os
from logging import getLogger

import boto3
import requests

log = getLogger(__name__)

URL: str = 'https://api.punkapi.com/v2/beers/random'


def get_record_from_api(url: str):
    """
    Gets data from Punk API
    :param url: URL to request for
    :return: json
    """
    try:
        response = requests.get(url)
        return response.json()[0]
    except Exception as err:
        log.info('An error occurred during the request. Error: ', err)
        raise err


def send_message_to_ks(msg: str, stream_name: str):
    """
    Sends unique message to Kinesis Stream
    :param msg: Message to send
    :param stream_name: Name of the Kinesis Stream
    :return: dict
    """
    client = boto3.client('kinesis')
    log.info('Sending message to Kinesis Stream')
    return client.put_record(
        Data=bytes(msg, 'utf-8'),
        PartitionKey='0',
        StreamName=stream_name
    )


def lambda_handler(event, context):
    log.info('Getting records from api')
    record = get_record_from_api(URL)
    log.info('Ingesting data on Kinesis Firestream')
    return send_message_to_ks(msg=json.dumps(record, ensure_ascii=False),
                              stream_name=os.environ['KINESIS_STREAM_NAME'])
