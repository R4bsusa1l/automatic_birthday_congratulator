import webbrowser
import pyautogui
import time
from datetime import date
from config import load_database_config
from connect import connect

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
        sql3 = 'SELECT recipientsid, firstname, Lastname, userkey, birthyear, phonenumber FROM recipients WHERE birthday = %s and birthmonth = %s;'
        cursor.execute(sql3, (todaysday, todaysmonth))
        birthdayRecipients = cursor.fetchall()
        for (recipientsId, firstName, LastName, userKey, birthyear, phonenumber) in birthdayRecipients:
            print('found: '.join(recipientsId))
            sql1 = 'SELECT messagekey FROM recipient_message WHERE recipientkey = %s'
            cursor.execute(sql1, (recipientsId,))
            previouslyUsedMessages = cursor.fetchall()

            usedmessages = [messageKey[0] for messageKey in previouslyUsedMessages]
            if usedmessages:
                placeholders = ', '.join(['%s'] * len(usedmessages))
                sql2 = f'SELECT birthdaymessage FROM birhtday_messages WHERE messageid NOT IN ({placeholders})'
                cursor.execute(sql2, usedmessages)
            else:
                sql2 = 'SELECT birthdaymessage FROM birhtday_messages'
                cursor.execute(sql2)
            birthdayMessage = cursor.fetchall()
            cleanedbirthdaymessage = retrieveWorkableBirthdayMessage(firstName, LastName, today.year - birthyear, birthdayMessage)
            activateWhatsapp(phonenumber, firstName, LastName, cleanedbirthdaymessage)

def retrieveWorkableBirthdayMessage(firstname, lastname, age, birthdaymessage):
    birthdaymessage.replace('PersonX', firstname)
    if abs(age) % 10 == 3:
        birthdaymessage.replace('??th', '??nd')
    birthdaymessage.replace('??', age)
    return birthdaymessage
    


def activateWhatsapp(phonenumber, firstName, LastName, birthdayMessage):
    print('Opening Whatsapp')
    site = "https://web.whatsapp.com/"

    try:
        webbrowser.open_new_tab(site.strip())
    except Exception as e:
        print(e)

    # Wait for the browser to open
    time.sleep(5)

    # Find the browser window (adjust title as needed)
    windows = pyautogui.getWindowsWithTitle("WhatsApp") #Adjust this title if needed.
    print (windows)
    if windows:
        window = windows[0]  # Get the first window matching the title
        window.activate()  # Bring the window to the foreground

        # Resize and position the window
        window.resizeTo(800, 800) # example size. adjust as needed.
        window.moveTo(0, 0) # move to top left.

        # Wait for the window to resize and move
        time.sleep(2)

    pyautogui.mouseInfo()
    pyautogui.click(345, 120)  # Move the mouse to "open new chat". 
    pyautogui.click(150, 175)   # Move the mouse to "search for contact".
    pyautogui.write(phonenumber, interval=0.25) # type name of recipient (must match exactly given name in contacts/Whatsapp)           // might work with phone number as well
    pyautogui.click(230, 350)   # Move the mouse to select the entered contact.
    pyautogui.click(170, 310)   # Move the mouse to select the entered contact. click again for confirmation
    pyautogui.click(100, 300)   # Move the mouse to select the entered contact. click again for double confirmation
    pyautogui.click(550, 760)   # Move the mouse to the text box for String entry.
    pyautogui.write(birthdayMessage, interval=0.25) # type birthday message
    pyautogui.click(750, 760)   # Move the mouse to the text box for String entry.

    window.close()

if __name__ == '__main__': main()