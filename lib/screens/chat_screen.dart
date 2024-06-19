import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String displayName;
  final String middleName;
  final String lastName;
  final String email;

  const ChatScreen({
    Key? key,
    required this.displayName,
    required this.middleName,
    required this.lastName,
    required this.email,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User _user;
  bool consentGiven = false;

  @override
  void initState() {
    super.initState();
    _signInAnonymously();
  }

  void _signInAnonymously() async {
    UserCredential userCredential = await _auth.signInAnonymously();
    _user = userCredential.user!;
    _sendInitialMessages();
  }

  void _sendInitialMessages() async {
    await FirebaseFirestore.instance.collection('chats').add({
      'text':
          'Hello! Under the Data Privacy Act (DPA) of 2012 in the Philippines, we need your consent to collect your personal information (e.g., your name and email). Is this okay with you? https://privacy.gov.ph/data-privacy-act/\n\nBy using PH-ELSA, you consent to the collection and use of your personal information (e.g., name and email) under the Data Privacy Act (DPA) of 2012 in the Philippines.',
      'sender': 'System',
      'email': 'system@ph-elsa.com',
      'timestamp': Timestamp.now(),
    });

    setState(() {
      consentGiven = false; // Show the consent button after the initial message
    });
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('chats').add({
        'text': _controller.text,
        'sender':
            '${widget.displayName} ${widget.middleName} ${widget.lastName}',
        'email': widget.email,
        'timestamp': Timestamp.now(),
      });
      _controller.clear();
    }
  }

  void _sendConsent() {
    FirebaseFirestore.instance.collection('chats').add({
      'text': 'I Understand',
      'sender': '${widget.displayName} ${widget.middleName} ${widget.lastName}',
      'email': widget.email,
      'timestamp': Timestamp.now(),
    });
    FirebaseFirestore.instance.collection('chats').add({
      'text':
          'Please state your concern and wait for any notification with regards to reply.',
      'sender': 'System',
      'email': 'system@ph-elsa.com',
      'timestamp': Timestamp.now(),
    });
    setState(() {
      consentGiven = true;
    });
  }

  Widget _buildMessageItem(Map<String, dynamic> message) {
    bool isMe = message['email'] == widget.email;
    bool isSystem = message['email'] == 'system@ph-elsa.com';
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.purple : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: isMe ? null : Border.all(color: Colors.purple),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['text'],
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black,
                fontStyle: isSystem ? FontStyle.italic : FontStyle.normal,
              ),
            ),
            SizedBox(height: 5),
            Text(
              message['timestamp']
                  .toDate()
                  .toLocal()
                  .toString()
                  .substring(11, 16),
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150'), // Placeholder for user's profile image
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${widget.displayName} ${widget.middleName} ${widget.lastName}'),
                Text('Online',
                    style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(icon: Icon(Icons.video_call), onPressed: () {}),
          IconButton(icon: Icon(Icons.call), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                var messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    var message =
                        messages[index].data() as Map<String, dynamic>;
                    return _buildMessageItem(message);
                  },
                );
              },
            ),
          ),
          if (!consentGiven)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _sendConsent,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'I Understand',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          if (consentGiven)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
