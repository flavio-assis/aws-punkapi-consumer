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