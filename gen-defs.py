#!/usr/bin/env python3

from jinja2 import Environment, FileSystemLoader, Template
import sys
import argparse
import yaml
import os


class DefGenerator:

    def __init__(self, basepath, outputdir=None, defs_yml=None, templatedir=None):
        if not templatedir: templatedir = "{0}/templates".format(basepath)
        if not defs_yml: defs_yml = "{0}/defs.yml".format(args.basepath)
        if not outputdir: outputdir = "{0}/include/defs".format(basepath)
        self.outputdir = outputdir
        env = Environment(loader=FileSystemLoader(templatedir),
                          lstrip_blocks=True, trim_blocks=True)
        self.templates = {}
        for name in ['property', 'element']:
            self.templates[name] = env.get_template(name)
        with open(defs_yml) as f:
            self.specs = yaml.load(f)
        os.makedirs(self.outputdir, exist_ok=True)

    def generate(self):
        for cat in self.templates:
            sys.stderr.write("[{0}]\n\t".format(cat))
            for name in self.specs[cat]:
                definition = self.specs[cat][name]
                definition['name'] = name
                fname = "{0}/{1}".format(self.outputdir, name)
                with open(fname, 'w') as f:
                    sys.stderr.write(name + " ")
                    f.write(self.templates[cat].render(definition))
            sys.stderr.write("\n")

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--basepath', default=os.getcwd(),
            help='Path for defs.yml and templates/. Default: %(default)s')
    parser.add_argument('--defs_yml',
            help='Definitions YAML. Default: [basepath]/defs.yml')
    parser.add_argument('--templatedir',
            help='Templates directory. Default: [basepath]/templates')
    parser.add_argument('--outputdir',
            help='Output directory. Default: [basepath]/include/defs')
    args = parser.parse_args()
    generator = DefGenerator(**vars(args))
    generator.generate()
