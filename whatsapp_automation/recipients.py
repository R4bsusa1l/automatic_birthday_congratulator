from datetime import date
from config import load_database_config
from connect import connect
from whatsapp_automation import activateWhatsapp 

def main():
    evaluateBirthdayRecipients()


def evaluateBirthdayRecipients():
    try:
        config = load_database_config()
        try:
            conn = connect(config)
        except Exception as e:
            print(f"Failed to connect to the database: {e}")
        print('so far so good')
        if conn is None:
            raise Exception("Failed to connect to the database.")
        print('Connection successful')
    except Exception as e:
        print(f"Error: {e}")
        return
    
    today = date.today()
    todaysday = today.day
    todaysmonth = today.month
    with conn.cursor() as cursor:
        sql3 = 'SELECT recipientsid, firstname, birthyear, phonenumber FROM recipients WHERE birthday = %s and birthmonth = %s;'
        cursor.execute(sql3, (todaysday, todaysmonth))
        birthdayRecipients = cursor.fetchall()
        for (recipientsId, firstName, birthyear, phonenumber) in birthdayRecipients:
            sql1 = 'SELECT messagekey FROM recipient_message WHERE recipientkey = %s'
            cursor.execute(sql1, (recipientsId,))
            previouslyUsedMessages = cursor.fetchall()

            usedmessages = [messageKey[0] for messageKey in previouslyUsedMessages]
            if usedmessages:
                placeholders = ', '.join(['%s'] * len(usedmessages))
                sql2 = f'SELECT birthdaymessage FROM birthday_messages WHERE messageid NOT IN ({placeholders}) LIMIT 1'
                cursor.execute(sql2, usedmessages)
            else:
                sql2 = 'SELECT birthdaymessage FROM birthday_messages LIMIT 1'
                cursor.execute(sql2)
            result = cursor.fetchone()
            if result:
                birthdayMessage = result[0]
                cleanedbirthdaymessage = retrieveWorkableBirthdayMessage(firstName, today.year - birthyear, birthdayMessage)
                activateWhatsapp(phonenumber, cleanedbirthdaymessage)
            

def retrieveWorkableBirthdayMessage(firstname, age, birthdaymessage):
    birthdaymessage = birthdaymessage.replace('PersonX', firstname)
    if abs(age) % 10 == 3:
        birthdaymessage = birthdaymessage.replace('??th', '??nd')
    birthdaymessage = birthdaymessage.replace('??', str(age))
    return birthdaymessage
    

if __name__ == '__main__': main()