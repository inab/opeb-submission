#!/usr/bin/env python3
from configparser import ConfigParser


class NextflowConfigGenerator(ConfigParser):
    def __init__(self, config_file):
        ConfigParser.__init__(self, allow_no_value=True)
        self.read(config_file)
        self.input_data_list = []
        self.string_phases = []
        self.publishDir = 'nextflow_working_directory'

    def _generate_header(self):
        generated_list = []
        generated_list.append('#!/usr/bin/env nextflow')
        for data in self['InputData']:
            self.input_data_list.append(data)
            generated_list.append(f'params.in = "{data}"')
        self.string_phases.append('\n'.join(generated_list))

    def _generate_dockerPreconditions(self):
        generated_list = []
        generated_list.append('process dockerPreconditions {')
        generated_list.append('')
        generated_list.append(self._generate_publishDir())
        generated_list.append('')
        generated_list.append(
            self._generate_files('docker_image_dependency', mode='input'))
        generated_list.append('\t"""')
        for section in self.sections():
            if section == 'InputData':
                continue
            for image_name, path in self[section].items():
                if path is None:
                    generated_list.append(f'\tdocker pull {image_name}')
                else:
                    generated_list.append(
                        f'\tdocker build -t {image_name} {path}')
        generated_list.append('')
        generated_list.append('\ttouch docker_image_dependency')
        generated_list.append('\t"""')
        generated_list.append('}')
        self.string_phases.append('\n'.join(generated_list))

    def _generate_publishDir(self):
        return f"\tpublishDir '{self.publishDir}', mode: 'copy', overwrite: true"

    def _generate_files(self, files, mode='input'):
        generated_list = []
        generated_list.append(f'{"input" if mode == "input" else "output"}:')
        if not isinstance(files, list):
            files = [files]
        for file in files:
            generated_list.append(f'\tfile {file}')
        generated_list.append('')

        return '\n'.join(generated_list)

    def __str__(self):
        if not self.string_phases:
            self._generate_header()
            self._generate_dockerPreconditions()
        return '\n'.join(self.string_phases)


nextflowConfig = NextflowConfigGenerator('config.ini')
print(nextflowConfig)
