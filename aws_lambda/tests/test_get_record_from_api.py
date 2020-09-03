from unittest import TestCase
from unittest.mock import patch

from main import get_record_from_api, URL
from tests.utils.response_mocker import MockResponse


class TestGetRecordFromApi(TestCase):
    @patch('requests.get')
    def test_success_response(self, mock_requests_get):
        mock_requests_get.return_value = MockResponse(json_data=[{'data': 'foo'}], status_code=200)
        self.assertEqual(get_record_from_api('foo.com'), {'data': 'foo'})

    @patch('requests.get')
    def test_http_exception(self, mock_requests_get):
        mock_requests_get.return_value = MockResponse(json_data=[{'data2': 'foo2'}], status_code=404)
        self.assertRaises(Exception, get_record_from_api('foo.com'))

    def test_method_return_a_dict(self):
        response = get_record_from_api(URL)

        self.assertIsInstance(response, dict)
