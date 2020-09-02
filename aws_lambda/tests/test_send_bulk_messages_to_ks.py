import os
from unittest import TestCase
from unittest.mock import patch

from main_async import send_messages_to_ks


class TestSendBulkMessagesToKs(TestCase):
    def setUp(self):
        os.environ['KINESIS_STREAM_NAME'] = 'FooStream'

    @patch('boto3.client')
    def test_check_call_to_kinesis_client(self, mock_boto3_client):
        mock_boto3_client.return_value.__enter__.put_records.return_value = None

        records = ['{"id": 0, "value": "foo"}', '{"id": 1, "value": "foo2"}']
        send_messages_to_ks(records=records, stream_name='foo')

        mock_boto3_client.assert_called_once_with('kinesis')
