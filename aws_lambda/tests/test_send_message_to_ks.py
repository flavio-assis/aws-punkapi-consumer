import os
from unittest import TestCase
from unittest.mock import patch

from main import send_message_to_ks


class TestSendMessageToKinesisStream(TestCase):
    def setUp(self) -> None:
        os.environ['KINESIS_STREAM_NAME'] = 'FooStream'

    @patch('boto3.client')
    def test_check_call_to_kinesis_client(self, mock_boto3_client):
        mock_boto3_client.return_value.__enter__.put_records.return_value = None

        msg = 'foo text'
        send_message_to_ks(msg=msg)

        mock_boto3_client.assert_called_once_with('kinesis')
