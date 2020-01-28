import configparser
config = configparser.ConfigParser()
config.read('~/Desktop/config.ini')
config.get('DATABASE', 'HOST')
config['DATABASE']['HOST']
