import psycopg2

def connect(config):

    try:
        conn = psycopg2.connect(**config)
        print('connect database successful')
        return conn
    except psycopg2.OperationalError as e:
        print(f"OperationalError: {e}")
        raise
    except Exception as e:
        print(f"Error: {e}")
        raise