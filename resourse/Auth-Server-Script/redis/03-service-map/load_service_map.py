#!/usr/bin/env python3.6

import gspread
from oauth2client.service_account import ServiceAccountCredentials
import json
import redis
import yaml
import time
import sys


class LoadRedisData(object):

    _CONFIG = "../redis.yml"
    _CREDENTIAL = '../../config/credential.json'
    _GOOGLE_SHEET_NAME = 'HOOTHUT__Component-Feature-Service'

    def load_script(self, json_file_name):
        services = {}
        worksheet = self.g.open(self._GOOGLE_SHEET_NAME)
        containers = ["antarika", "cecurity", "ump", "drws", "insurance"]

        for container in containers:
            sheet = worksheet.worksheet(container)
            list_of_lists = sheet.get_all_values()
            for item in list_of_lists[4:]:
                role = item[7].replace(' ', '')
                if role == "":
                    continue

                product = item[1]
                component = item[2]
                feature = item[3]
                version = item[4]
                service = item[5]

                roles = role.split(",")
                url = product + "/" + component + "/" + feature + "/" + version + "/" + service
                services[url] = {"product": product, "component": component, "feature": feature, "version": version,
                                 "service": service, "roles": roles}

        with open(json_file_name, 'w') as jsonFile:
            print(json.dumps(services, indent=4), file=jsonFile)

    def generate_script(self, deployment_type, json_file_name):
        with open(json_file_name, 'r') as data_file:
            services = json.loads(data_file.read())
        index = 0
        for k, v in services.items():
            index = index + 1

            if deployment_type == 'dev':
                v["roles"] = v["roles"] + ["REGRESSION"]

            self.pipe.hset('ServiceMap', k, json.dumps(v))
            if index % 100 == 0:
                self.pipe.execute()
        self.pipe.execute()
        self.calculate_time(services.items())

    def remove_service_map(self):
        self.pipe.delete('ServiceMap')
        self.pipe.execute()

    def calculate_time(self, service_list):
        millis = int(round(time.time() * 1000)) - self.start_time
        seconds = (millis / 1000) % 60
        print('3. ServiceMap : {}, in {} seconds'.format(len(service_list), int(seconds)))

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
            json_file_name = 'ServiceMap.json'
            self.load_script(json_file_name)
        self.set_up_redis()
        self.remove_service_map()
        self.generate_script(deployment_type, json_file_name)


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
