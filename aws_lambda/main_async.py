import asyncio
import json
import os
from logging import getLogger
from typing import List

import boto3
from aiohttp import ClientSession
from aiohttp.http_exceptions import HttpProcessingError
from retrying import retry

log = getLogger(__name__)

URL: str = 'https://api.punkapi.com/v2/beers/random'
MAX_REQUESTS: int = int(os.getenv('MAX_REQUESTS', 500))


@retry(stop_max_attempt_number=5, wait_random_min=1, wait_random_max=3)
async def get_records_from_api(url: str, session: ClientSession):
    """
    Gets data asynchronously from Punk API
    :param url: URL to request for
    :param session: HTTP Session
    :return: json
    """
    try:
        response = await session.request(method='GET', url=url)
        response.raise_for_status()
        log.info(f"Response status ({url}): {response.status}")
        return await response.json()
    except HttpProcessingError as http_err:
        log.info('An error occurred during the request. Error: ', http_err)
        raise http_err
    except Exception as err:
        log.info('Unable to proceed: Error: ', err)
        raise err


def send_messages_to_ks(records: List[str], stream_name: str):
    """
    Sends a list of records to Kinesis Stream
    :param msg: Message to send
    :param stream_name: Name of the Kinesis Stream
    :return: dict
    """
    log.info('Sending message to Kinesis Stream')
    client = boto3.client('kinesis')
    return client.put_records(
        Records=[
            {
                'Data': record + '\n',
                'PartitionKey': '1'
            } for record in records],
        StreamName=stream_name
    )


async def run_collector(url: str, session: ClientSession):
    """
    Wrapper for asynchronous execution
    """
    try:
        response = await get_records_from_api(url, session)
        event_data = json.dumps(response[0], ensure_ascii=False)
        log.info(f'Record to stream: {event_data}')
        return event_data
    except Exception as err:
        log.info('Unable to proceed: Error: ', err)
        raise err


async def main():
    async with ClientSession() as session:
        log.info('Getting records from Api')
        data_records = await asyncio.gather(*[run_collector(URL, session) for i in range(MAX_REQUESTS)])

    log.info('Sending records to Kinesis Stream')
    send_messages_to_ks(records=data_records, stream_name=os.environ['KINESIS_STREAM_NAME'])


def lambda_handler(event, context):
    asyncio.run(main())
