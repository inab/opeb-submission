#!/usr/bin/env python3
from configparser import ConfigParser


class NextflowConfigGenerator(ConfigParser):
    def __init__(self, config_file):
        ConfigParser.__init__(self, allow_no_value=True)
        self.read(config_file)
        self.data_list = []
        self.string_phases = []
        self.publishDir = 'nextflow_working_directory'

    def _generate_header(self):
        generated_strings = []
        generated_strings.append('#!/usr/bin/env nextflow')
        for data in self['InputData']:
            self.data_list.append(data)
            generated_strings.append(f'params.in = "{data}"')
        self.string_phases.append('\n'.join(generated_strings))

    def _generate_dockerPreconditions(self):
        generated_string = []
        generated_string.append('process dockerPreconditions {')
        generated_string.append(self._generate_publishDir())
        for section in self.sections():
            if section == 'InputData':
                continue
            for image_name, path in self[section].items():
                if path is None:
                    generated_string.append(f'\tdocker pull {image_name}')
                else:
                    generated_string.append(
                        f'\tdocker build -t {image_name} {path}')
        generated_string.append('}')
        self.string_phases.append('\n'.join(generated_string))

    def _generate_publishDir(self):
        return f"\tpublishDir '{self.publishDir}', mode: 'copy', overwrite: true"

    def __str__(self):
        if not self.string_phases:
            self._generate_header()
            self._generate_dockerPreconditions()
        return '\n'.join(self.string_phases)


nextflowConfig = NextflowConfigGenerator('config.ini')
print(nextflowConfig)
