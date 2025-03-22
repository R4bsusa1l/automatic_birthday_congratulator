import webbrowser
import pyautogui
import time
import os

def main():
    activateWhatsapp("+123456789", "happy birthday")

def activateWhatsapp(phonenumber, birthdayMessage):
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

    pyautogui.click(345, 120)  # Move the mouse to "open new chat". 
    pyautogui.click(150, 175)   # Move the mouse to "search for contact".
    pyautogui.write(phonenumber, interval=0.25) # type name of recipient (must match exactly given name in contacts/Whatsapp)           // might work with phone number as well
    pyautogui.click(230, 350)   # Move the mouse to select the entered contact.
    pyautogui.click(170, 310)   # Move the mouse to select the entered contact. click again for confirmation
    pyautogui.click(100, 300)   # Move the mouse to select the entered contact. click again for double confirmation
    pyautogui.click(550, 760)   # Move the mouse to the text box for String entry.
    pyautogui.write(birthdayMessage, interval=0.25) # type birthday message
    pyautogui.click(750, 760)   # Move the mouse to the text box for String entry.

    #pyautogui.mouseInfo()
    os.system("taskkill /IM chrome.exe /F")


if __name__ == '__main__': main()