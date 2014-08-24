SERVER_INFO='http://crawler.6estates.com:9001/cluster/server'

import os
BASE_DIR = os.path.abspath(os.path.dirname(__file__))

UA_POOL=[
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.4 (KHTML, like Gecko) Chrome/22.0.1229.79 Safari/537.4',
    'Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)',
    'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20100101 Firefox/15.0.1',
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.6 (KHTML, like Gecko) Chrome/20.0.1092.0 Safari/536.6',
    'Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2',
]

LANGUAGE_POOL=[
        'zh-CN,zh;q=0.8,en-US;q=0.6,en;q=0.4',
        #'zh-TW,zh;q=0.8,en-US;q=0.6,en;q=0.4',
        #'en-US,en;q=0.8',
]

RETRY_CNT_PER_URL = 3
READ_TIMEOUT_LIMIT = 10
RENDER_TIMEOUT_LIMIT = 30

UPDATE_INTERVAL = 0.1

INTEREST_HEADER_FIELDS = ['content-type', 'date', 'etag', 'last-modified']

FAIL_REASON={
        'ConnectionError': 1, # DNS Failed, refuse connection
        'HTTPError': 2, # Status Code return 4xx or 5xx
        'Timeout': 3, # Server do not return a response
        'TooManyRedirects': 4,
        'WrongExtension': 5,
        'Other': 6,
        'UnicodeDecodeError': 7,
        'NoResourceError': 8,
        'RenderError': 9,
}

#wsdl for rss
VALID_EXTENSION=set(['.html', '.htm', '.json', '.js', '.txt', '.xml', '.wsdl'])

### About TaskGetter/Submitter
BASIC_WAIT_TIME = 1
MAX_WAIT_TIME = 2**6
QUEUE_MIN_LIMIT = 1 #when queue is shorter than this, start request

SERVER_READ_TIMEOUT = 10

DEFAULT_RESOURCE_QUOTA = 10
