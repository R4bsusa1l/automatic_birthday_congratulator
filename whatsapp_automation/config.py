from configparser import ConfigParser
import os

def load_database_config(filename='database.ini', section='postgresql'):
    try:
        parser = read_config()
    except Exception as e:
        print(f"Failed to load config: {e}")
    

    db_config = {}
    if parser.has_section(section):
        params = parser.items(section)
        for param in params:
            db_config[param[0]] = param[1]
    else:
        raise Exception(f"Section {section} not found in the {filename} file")

    return db_config

def read_config(filename='database.ini', encoding='unicode_escape'):
    print(os.path.abspath('database.ini'))
    config = ConfigParser()
    try:
        config.read(filename, encoding=encoding)
        return config
    except UnicodeDecodeError:
        print(f"Error: Unable to decode {filename} with {encoding} encoding.")
        raise
    except FileNotFoundError:
        print(f"Error: {filename} not found.")
        raise