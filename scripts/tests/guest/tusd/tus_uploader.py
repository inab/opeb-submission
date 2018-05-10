#!/usr/bin/env python3
from tusclient import client
my_client = client.TusClient('http://localhost:1080/files/')
uploader = my_client.uploader('test.txt', chunk_size=200, metadata={
                              "filename": "test.txt"})
uploader.upload()
