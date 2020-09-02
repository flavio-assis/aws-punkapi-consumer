import os
from unittest import TestCase
from unittest.mock import patch

from main import send_message_to_ks
import main

class TestSendMessageToKinesisStream(TestCase):
    def setUp(self) -> None:
        os.environ['KINESIS_STREAM_NAME'] = 'FooStream'

    @patch('boto3.client')
    def test_check_call_to_kinesis_client(self, mock_boto3_client):
        mock_boto3_client.return_value.__enter__.put_records.return_value = None

        msg = 'foo text'
        send_message_to_ks(msg=msg, stream_name='foo')

        mock_boto3_client.assert_called_once_with('kinesis')

    @patch('botocore.client')
    def test_if_method_sends_the_right_msg(self, mock_kinesis_client):

        mock_kinesis_client.__enter__.return_value.Kinesis.__enter__.return_value.put_record.return_vale = {'foo': 'test'}
        msg = 'foo text'
        send_message_to_ks(msg=msg, stream_name='foo')

        mock_kinesis_client.__enter__.return_value.Kinesis.__enter__.return_value.put_record.assert_called_once_with(msg=msg)
