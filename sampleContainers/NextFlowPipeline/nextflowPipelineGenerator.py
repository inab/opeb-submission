#!/usr/bin/env python3
from configparser import ConfigParser


class NextflowConfigGenerator(ConfigParser):
    def __init__(self, config_file):
        ConfigParser.__init__(self, allow_no_value=True)
        self.read(config_file)
        self.input_data = []
        self.paremeters = {}
        self.string_phases = []
        self.publishDir = 'nextflow_working_directory'

    def _generate_header(self):
        generated_lines = []
        generated_lines.append('#!/usr/bin/env nextflow')
        generated_lines.append('')
        for parameter in self['Parameters']:
            value = self['Parameters'][parameter]
            self.paremeters[parameter] = value
            generated_lines.append(f'params.{parameter} = "{value}"')
        generated_lines.append('')
        for data in self['InputData']:
            self.input_data.append(data)
            generated_lines.append(f'params.in = "{data}"')
        self.string_phases.append('\n'.join(generated_lines))

    def _generate_dockerPreconditions(self):
        generated_lines = []
        generated_lines.append('process dockerPreconditions {')
        generated_lines.append('')
        generated_lines.append(self._generate_publishDir())
        generated_lines.append('')
        generated_lines.append(
            self._generate_files('docker_image_dependency', mode='input'))
        generated_lines.append('\t"""')
        for section in self.sections():
            if section in ['Parameters', 'InputData']:
                continue
            for image_name, path in self[section].items():
                if path is None:
                    generated_lines.append(f'\tdocker pull {image_name}')
                else:
                    generated_lines.append(
                        f'\tdocker build -t {image_name} {path}')
        generated_lines.append('')
        generated_lines.append('\ttouch docker_image_dependency')
        generated_lines.append('\t"""')
        generated_lines.append('}')
        self.string_phases.append('\n'.join(generated_lines))

    def _generate_checkResults(self):
        generated_lines = []
        generated_lines.append('process checkResults {')
        generated_lines.append('')
        generated_lines.append(self._generate_publishDir())
        generated_lines.append('')
        generated_lines.append(self._generate_files(
            ['docker_image_dependency'] + self.input_data, mode='input'))
        generated_lines.append('')
        generated_lines.append(self._generate_files(
            'canonical_results', mode='output'))
        generated_lines.append('')
        generated_lines.append('\t"""')
        generated_lines.append(
            f' \tdoValidateAndCopy.sh {" ".join((map(lambda l: "$"+l, self.input_data)))} canonical_results')
        generated_lines.append('\t"""')
        generated_lines.append('}')

        self.string_phases.append('\n'.join(generated_lines))

    def _generate_publishDir(self):
        return f"publishDir '{self.publishDir}', mode: 'copy', overwrite: true"

    def _generate_files(self, files, mode='input'):
        generated_lines = []
        generated_lines.append(f'{"input" if mode == "input" else "output"}:')
        if not isinstance(files, list):
            files = [files]
        for file in files:
            generated_lines.append(f'\tfile {file}')
        generated_lines.append('')

        return '\n'.join(generated_lines)

    def __str__(self):
        if not self.string_phases:
            self._generate_header()
            self._generate_dockerPreconditions()
            self._generate_checkResults()
        return '\n'.join(self.string_phases)


nextflowConfig = NextflowConfigGenerator('config.ini')
print(nextflowConfig)
