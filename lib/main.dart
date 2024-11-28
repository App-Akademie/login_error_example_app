import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: RegisterWidget(),
        ),
      ),
    );
  }
}

// Daten übergeben, damit sich ein Benutzer registrieren kann.
// Wir brauchen also Benutzername und Passwort.
// Mögliche Fehler:
// - Benutzername existiert schon (Benutzer schon da).
// - Leeren Benutzername angegben.
// Rückgabe der Funktion: String mit Erfolg oder Fehler
// Beispiele:
// - "200"
// - "404"
// - "409"
Future<String> registerUser(String userName, String passWord) async {
  // userName und passWord nach JSON encodieren.
  // {"username": "testuser", "password": "mypassword"}
  final userDataMap = {"username": userName, "password": passWord};
  String jsonEncoded = jsonEncode(userDataMap);
  // Aufruf machen.
  try {
    final http.Response response = await http.post(
      Uri.parse("http://localhost:8080/register"),
      body: jsonEncoded,
    );

    return response.statusCode.toString();
  } on http.ClientException catch (e) {
    log("$e");
    return "Keine Verbindung zum Server";
  } catch (e) {
    return "Exception, call customer support.";
  }
}

class RegisterWidget extends StatefulWidget {
  const RegisterWidget({super.key});

  @override
  State<RegisterWidget> createState() => _RegisterWidgetState();
}

class _RegisterWidgetState extends State<RegisterWidget> {
  String userName = "";
  String passWord = "";
  String message = "";

  // Methode, die die Arbeit macht (Funktion aufruft etc.)
  void tryRegisterUser() async {
    // Versucht einen User zu registrieren.
    final String result = await registerUser(userName, passWord);
    // Setzt je nach Erfolg entsprechende Variablen.
    // 200, 400, 409, 500, ...
    if (result == "200") {
      message = "Registrierung erfolgreich";
    } else if (result == "400") {
      message = "Daten für die Anmeldung haben gefehlt";
    } else if (result == "409") {
      message = "Benutzer gibt es bereits";
    } else if (result == "Exception") {
      message = "Es gab eine Ausnahme";
    } else if (result == "Keine Verbindung zum Server") {
      message = result;
    } else if (result == "Exception, call customer support.") {
      message = result;
    } else {
      message = "Unbekannter Fehler";
    }
    // Updated die UI.
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32, right: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Registrieren",
            style: TextStyle(fontSize: 36),
          ),
          const SizedBox(height: 32),
          TextField(
            onChanged: (value) => userName = value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: (value) => passWord = value,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: tryRegisterUser,
            child: const Text("Register"),
          ),
          const SizedBox(height: 32),
          Text(message),
        ],
      ),
    );
  }
}
