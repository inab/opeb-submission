#!/usr/bin/env python3
import configparser

config = configparser.ConfigParser(allow_no_value=True)

config.read('config.ini')


def generate_header(config, data_list):
    generated_strings = []
    generated_strings.append('#!/usr/bin/env nextflow')
    for data in config['InputData']:
        data_list.append(data)
        generated_strings.append(f'params.in = "{data}"')
    return '\n'.join(generated_strings)


def generate_dockerPreconditions(config):
    generated_string = []
    generated_string.append('process dockerPreconditions {')
    for section in config.sections():
        for image_name, path in config[section].items():
            if path is None:
                generated_string.append(f'\tdocker pull {image_name}')
            else:
                generated_string.append(
                    f'\tdocker build -t {image_name} {path}')
    generated_string.append('}')
    return '\n'.join(generated_string)


data_list = []
string_phases = []

string_phases.append(generate_header(config, data_list))
string_phases.append(generate_dockerPreconditions(config))
print('\n'.join(string_phases))
