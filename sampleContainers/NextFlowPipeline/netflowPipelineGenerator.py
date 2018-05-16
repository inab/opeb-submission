#!/usr/bin/env python3
import configparser

config = configparser.ConfigParser(allow_no_value=True)

config.read('config.ini')


def generate_dockerPreconditions(config):
    generated_string = 'process dockerPreconditions {\n'
    for section in config.sections():
        for image_name, path in config[section].items():
            if path is None:
                generated_string += f'\tdocker pull {image_name}\n'
            else:
                generated_string += f'\tdocker build -t {image_name} {path}\n'
    generated_string += '}'
    return generated_string


print(generate_dockerPreconditions(config))
