import os
from unittest import TestCase
from unittest.mock import patch

from main_async import send_messages_to_ks

class TestSendBulkMessagesToKs(TestCase):
    def setUp(self):
        os.environ['KINESIS_STREAM_NAME'] = 'FooStream'

    @patch('botocore.client')
    def test_if_method_sends_the_right_msg(self, mock_kinesis_client):
        mock_kinesis_client.__enter__.return_value.Kinesis.__enter__.return_value.put_records.return_vale = {
            'foo': 'test'}

        msg = ["{'id': 0, 'value': 'foo'}", "{'id': 1, 'value': 'foo2'}"]

        send_messages_to_ks(records=msg, stream_name='foo')

        mock_kinesis_client.__enter__.return_value.Kinesis.__enter__.return_value.put_records.assert_called_once_with(
            msg=msg)
