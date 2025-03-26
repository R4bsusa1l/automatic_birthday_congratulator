package com.automatic_birthday_congratulator.sample

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.provider.Settings
import android.widget.Toast
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.material3.Button
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.TextFieldValue
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import com.automatic_birthday_congratulator.sample.services.WhatsappAccessibilityService
import com.automatic_birthday_congratulator.sample.ui.theme.MyApplicationTheme


class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            MyApplicationTheme {
                val context = LocalContext.current
                enableAccessibilityService(context)
                MainScreen(context)
            }
        }
    }
}

@Composable
fun MainScreen(context: Context) {

    var phoneNumber by remember { mutableStateOf(TextFieldValue("")) }
    var message by remember { mutableStateOf(TextFieldValue("")) }


    Scaffold(
        modifier = Modifier.fillMaxSize(),
    ) { innerPadding ->
        Column(
            modifier = Modifier
                .fillMaxSize()
                .padding(innerPadding)
                .padding(16.dp),
            verticalArrangement = Arrangement.Center,
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(text = "Phone Number:")
                Spacer(modifier = Modifier.width(8.dp))
                OutlinedTextField(
                    value = phoneNumber,
                    onValueChange = { phoneNumber = it },
                    modifier = Modifier.weight(1f)
                )
            }
            Spacer(modifier = Modifier.padding(8.dp))
            Row(
                modifier = Modifier.fillMaxWidth(),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Text(text = "Message:")
                Spacer(modifier = Modifier.width(8.dp))
                OutlinedTextField(
                    value = message,
                    onValueChange = { message = it },
                    modifier = Modifier.weight(1f)
                )
            }
            Spacer(modifier = Modifier.padding(16.dp))
            Button(onClick = {
                val number = phoneNumber.text
                val text = message.text
                if (number.isNotEmpty() && text.isNotEmpty()) {

                    val intent = Intent(Intent.ACTION_VIEW)
                    val uri = "https://api.whatsapp.com/send?phone=$number&text=$text"
                    intent.data = Uri.parse(uri)


                    try {
                        context.startActivity(intent)
                    } catch (e: Exception) {
                        Toast.makeText(
                            context,
                            "WhatsApp is not installed on this device.",
                            Toast.LENGTH_SHORT
                        ).show()
                    }
                } else {
                    Toast.makeText(
                        context,
                        "Please enter both a phone number and a message.",
                        Toast.LENGTH_SHORT
                    ).show()
                }
            }) {
                Text(text = "Send via WhatsApp")
            }
        }
    }
}

@Preview(showBackground = true)
@Composable
fun MainScreenPreview() {
    MyApplicationTheme {
        MainScreen(context = LocalContext.current)
    }
}

fun enableAccessibilityService(context: Context){
    val accessibilityCheck = AccessibilityCheck();
    if (!accessibilityCheck.isAccessibilityOn(context, WhatsappAccessibilityService::class.java)) {
        val intent2: Intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
        context.startActivity(intent2)
    }
}