import pytest
from unittest.mock import patch, MagicMock

# filepath: z:\VisualStudio\Projects\Initial Flutter Project\whatsapp_automation\test_access_webbrowser.py
from access_webbrowser import (
    evaluateBirthdayRecipients,
    retrieveWorkableBirthdayMessage,
    activateWhatsapp,
)

class TestAccessWebBrowser:
    @patch("access_webbrowser.load_database_config")
    @patch("access_webbrowser.connect")
    def test_evaluateBirthdayRecipients(self, mock_connect, mock_load_config):
        # Mock database config and connection
        mock_load_config.return_value = {"host": "localhost"}
        mock_conn = MagicMock()
        mock_connect.return_value = mock_conn

        # Mock database cursor and query results
        mock_cursor = MagicMock()
        mock_conn.cursor.return_value.__enter__.return_value = mock_cursor
        mock_cursor.fetchall.side_effect = [
            [(1, "John", 1992, "1234567890")],  # Recipients
            [("msg1",)],  # Previously used messages
        ]
        mock_cursor.fetchone.return_value = ("Happy Birthday, PersonX! You are ?? years old!",)  # Mocked message

        with patch("access_webbrowser.activateWhatsapp") as mock_activate:
            evaluateBirthdayRecipients()
            mock_activate.assert_called_once_with(
                "1234567890",
                "Happy Birthday, John! You are 33 years old!",
            )

    def test_retrieveWorkableBirthdayMessage(self):
        message = "Happy Birthday, PersonX! You are ?? years old!"
        result = retrieveWorkableBirthdayMessage("John", 33, message)
        assert result == "Happy Birthday, John! You are 33 years old!"

    @patch("access_webbrowser.webbrowser.open_new_tab")
    @patch("access_webbrowser.pyautogui")
    def test_activateWhatsapp(self, mock_pyautogui, mock_webbrowser):
        mock_window = MagicMock()
        mock_pyautogui.getWindowsWithTitle.return_value = [mock_window]

        activateWhatsapp("1234567890", "Happy Birthday!")
        mock_webbrowser.assert_called_once_with("https://web.whatsapp.com/")
        mock_pyautogui.getWindowsWithTitle.assert_called_once_with("WhatsApp")
        mock_window.activate.assert_called_once()
        mock_window.resizeTo.assert_called_once_with(800, 800)
        mock_window.moveTo.assert_called_once_with(0, 0)
        mock_pyautogui.click.assert_called()
        mock_pyautogui.write.assert_called_with("Happy Birthday!", interval=0.25)