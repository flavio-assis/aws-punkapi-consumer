from unittest import TestCase
from unittest.mock import patch

from main_async import get_records_from_api


class MockResponse:
    def __init__(self, json_data, status_code):
        self.json_data = json_data
        self.status_code = status_code

    def json(self):
        return self.json_data

    def text(self):
        return f'{self.json_data}'

    def status_code(self):
        return self.status_code


class TestGetRecordFromApi(TestCase):

    @patch('aiohttp.ClientSession')
    @patch('aiohttp.ClientSession.request')
    async def test_success_response(self, mock_session_request, mock_session):
        mock_session_request.return_value = MockResponse(json_data=[{'data': 'foo'}], status_code=200)
        self.assertEqual(await get_records_from_api('foo.com', mock_session), {'data': 'foo'})

    @patch('aiohttp.ClientSession')
    @patch('aiohttp.ClientSession.request')
    async def test_http_exception(self, mock_session_request, mock_session):
        mock_session_request.return_value = MockResponse(json_data=[{'data2': 'foo2'}], status_code=404)
        self.assertRaises(Exception, await get_records_from_api('foo.com', mock_session))

    @patch('aiohttp.ClientSession')
    async def test_method_return_a_dict(self, mock_session):
        response = await get_records_from_api('foo.com', mock_session)

        self.assertIsInstance(response, dict)
