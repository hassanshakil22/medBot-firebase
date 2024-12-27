import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_authProject/features/user_auth/views/login_view.dart';
import 'package:firebase_authProject/features/user_auth/widgets/custom_button.dart';
import 'package:firebase_authProject/global/widgets/toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> messages = [];
  final ScrollController _scrollController = ScrollController();

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;
    setState(() {
      messages.add({'user': 'You', 'text': text});
      scrollbehaviour();

      print(messages);
    });
    _controller.clear();
    await getBotResponse(text);
  }

  Future<void> getBotResponse(String userMessage) async {
    setState(() {
      messages.add({'user': 'Bot', 'text': 'Typing...'});
      scrollbehaviour();
    });

    var apiKey = "AIzaSyCP8u0VXhkdv5z8lQsDnXu9pdyma_-Ptuo";
    var body = {
      "contents": [
        {
          "role": "user",
          "parts": [
            {"text": '''$userMessage'''}
          ]
        }
      ]
    };
    var url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey');

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(body));

      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        setState(() {
          messages.removeLast();
          messages.add({
            'user': 'Bot',
            'text': result["candidates"][0]['content']["parts"][0]["text"]
          });
          scrollbehaviour();
        });
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        messages.removeLast();
        messages.add({
          'user': 'Bot',
          'text': 'Error getting response. Please try again \n Error ${e}'
        });
        scrollbehaviour();
      });
    }
  }

  Widget _buildMessage(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          gradient: isUser
              ? LinearGradient(
                  colors: [Colors.blue[100]!, Colors.purple[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[200]!,
                    Colors.grey[400]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: isUser ? Colors.black : Colors.black87),
        ),
      ),
    );
  }

  @override
  initState() {
    super.initState();
    var apiKey = "AIzaSyAXaTSf0HDiVJlr3_HuRM_zo82PxJ5CJpo";
    var url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent?key=$apiKey');

    try {
      http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            "contents": [
              {
                "role": "user",
                "parts": [
                  {
                    "text":
                        '''Medbot, only answer questions related to health, medicine, and pharmaceuticals. If the user asks off-topic questions, kindly explain you're limited to medical topics. Refer to the user as ${FirebaseAuth.instance.currentUser?.displayName}.'''
                  }
                ]
              }
            ]
          }));
    } catch (e) {
      print(e);
    }
    messages.add({
      'user': 'Bot',
      'text':
          'hey ${FirebaseAuth.instance.currentUser?.displayName} ! welcome to our medical store \n this is a AI integrated ChatBot that will answer your queries \n you can ask questions like : \n - how much dosage risek 20 should i take? \n- What are the side effects of Panadol? \n- How should I take my antibiotics?  '
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(56.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.grey[200]!,
                Colors.grey[400]!,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent, // Transparent to show gradient

            title: Row(
              children: [
                Text(
                  'MedBot',
                  style: TextStyle(
                    foreground: Paint()
                      ..shader = const LinearGradient(
                        colors: <Color>[
                          Colors.blue,
                          Colors.purple,
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      height: 50,
                      width: 50,
                      child: Image.asset("assets/medbot_Logo.png")),
                ),
              ],
            ),
            centerTitle: true,
          ),
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade200,
                    Colors.purple.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: DrawerHeader(
                child: Row(
                  children: [
                    Text(
                      'Menu',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                    ),
                    Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FutureBuilder(
                          future: Future.value(
                              FirebaseAuth.instance.currentUser?.photoURL),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (snapshot.hasData &&
                                snapshot.data != null) {
                              return CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(snapshot.data as String),
                              );
                            } else {
                              return CircleAvatar(
                                radius: 25,
                                child: Icon(Icons.person),
                              );
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Text(
                          FirebaseAuth.instance.currentUser?.displayName ??
                              'User',
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
              },
            ),
            Spacer(),
            CustomButton(
              text: "LogOut",
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginView()),
                  (route) => false,
                );
                showToast(message: " successfully signed out");
              },
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isUser = messages[index]['user'] == 'You';
                return _buildMessage(messages[index]['text']!, isUser);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      hintStyle: TextStyle(
                        foreground: Paint()
                          ..shader = const LinearGradient(
                            colors: <Color>[
                              Colors.blue,
                              Colors.purple,
                            ],
                          ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors
                              .black, // Default border color (used as fallback)
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.black, // Border color when not focused
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: const BorderSide(
                          color: Colors.blue, // Border color when focused
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  scrollbehaviour() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }
}
