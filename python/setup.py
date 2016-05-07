#1/usr/bin/env python

from distutils.core import setup

setup(name='Sparrow',
	version='0.1',
	description='Deploy R models as a real-time API',
	author='Eric kramer',
	author_email='eric.kramer@dataiku.com',
	packages=['sparrow'],
	package_data={'sparrow' : ['templates/*.html', 'js/*.js']})