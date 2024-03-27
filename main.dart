import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Link Shortener',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Link Shortener'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _linkController = TextEditingController();
  String? _shortenedLink;

  void _shortenLink() async {
    String originalLink = _linkController.text.trim();
    String apiUrl = 'https://cleanuri.com/api/v1/shorten';
    var response =
        await http.post(Uri.parse(apiUrl), body: {'url': originalLink});
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      setState(() {
        _shortenedLink = jsonResponse['result_url'];
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  void _copyToClipboard() {
    if (_shortenedLink != null) {
      Clipboard.setData(ClipboardData(text: _shortenedLink!));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Link copied to clipboard!'),
      ));
    } else {}
  }

  @override
  void dispose() {
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: _linkController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your link',
                  ),
                  textAlign: TextAlign.center,
                )),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _shortenedLink ?? 'Your shortened link',
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: _copyToClipboard,
                ),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              onPressed: _shortenLink,
              icon: const Icon(Icons.link),
              label: const Text('Shorten Url'),
            ),
          ],
        ),
      ),
    );
  }
}
