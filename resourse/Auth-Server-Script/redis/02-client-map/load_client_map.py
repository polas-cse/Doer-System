#!/usr/bin/env python3.6

import json
import sys
import time

import gspread
import redis
import yaml
from oauth2client.service_account import ServiceAccountCredentials


class LoadRedisData(object):

    _CONFIG = "../redis.yml"
    _CREDENTIAL = '../../config/credential.json'
    _GOOGLE_SHEET_NAME = 'HOOTHUT__Application-Navigation-Page'

    def load_script(self, deployment_type, json_file_name):
        client_list = []

        if deployment_type == 'dev':
            worksheet = self.g.open(self._GOOGLE_SHEET_NAME).worksheet('dev-clients')
        else:
            worksheet = self.g.open(self._GOOGLE_SHEET_NAME).worksheet('prod-clients')

        range = worksheet.get_all_values()
        for row in range[1:]:
            applist = [x.strip() for x in row[4].split(',')]
            client_list.append({'client': row[2].upper(), 'type': row[3], 'description': row[1], 'applications': applist})

        with open(json_file_name, 'w') as jsonFile:
            print(json.dumps(client_list, indent=4), file=jsonFile)

    def generate_script(self, json_file_name):
        with open(json_file_name, 'r') as data_file:
            client_list = json.loads(data_file.read())

        for data in client_list:
            self.pipe.hset('ClientMap', data["client"], json.dumps(data))
        self.pipe.execute()
        self.calculate_time(client_list)

    def remove_client_map(self):
        self.pipe.delete('ClientMap')
        self.pipe.execute()

    def calculate_time(self, client_list):
        millis = int(round(time.time() * 1000)) - self.start_time
        seconds = (millis / 1000) % 60
        print('2. ClientMap : {}, in {} seconds'.format(len(client_list), int(seconds)))

    def tearDown(self):
        return

    def set_up_redis(self):
        with open(self._CONFIG) as stream:
            try:
                self.config = yaml.load(stream, Loader=yaml.FullLoader)
            except yaml.YAMLError as exc:
                print(exc)
        redis_pool = redis.ConnectionPool(host=self.config['redis']['host'],
            port=self.config['redis']['port'],
            password=self.config['redis']['password'],
            db=self.config['redis']['db'])
        self.redis = redis.Redis(connection_pool=redis_pool)
        self.pipe = self.redis.pipeline()

    def set_up_gsheet(self):
        self.scope = ['https://spreadsheets.google.com/feeds', 'https://www.googleapis.com/auth/drive']
        self.credentials = ServiceAccountCredentials.from_json_keyfile_name(self._CREDENTIAL, self.scope)
        self.g = gspread.authorize(self.credentials)

    def run(self, deployment_type='dev', json_file_name=None):
        self.start_time = int(round(time.time() * 1000))
        if json_file_name is None:
            self.set_up_gsheet()
            json_file_name = 'ClientMap.json'
            self.load_script(deployment_type, json_file_name)
        self.set_up_redis()
        self.remove_client_map()
        self.generate_script(json_file_name)


if __name__ == '__main__':
    redisData = LoadRedisData()
    if len(sys.argv) == 3:
        if sys.argv[1] not in ('dev', 'prod'):
            print("Please enter proper deploy type as argument (dev/prod)")
            exit(1)
        redisData.run(sys.argv[1], sys.argv[2])
    elif len(sys.argv) == 2:
        if sys.argv[1] not in ('dev', 'prod'):
            print("Please enter proper deploy type as argument (dev/prod)")
            exit(1)
        redisData.run(sys.argv[1])
    else:
        print("Please enter deploy type as argument (dev/prod)")
        exit(1)
