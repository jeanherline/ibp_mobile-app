import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';

class ChatScreen extends StatelessWidget {
  final String displayName;
  final String middleName;
  final String lastName;
  final String email;

  const ChatScreen({
    super.key,
    required this.displayName,
    required this.middleName,
    required this.lastName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Live Chat for Inquries'),
      ),
      body: Tawk(
        directChatLink:
            'https://tawk.to/chat/666c61ce9a809f19fb3dc400/1i0bls3qi',
        visitor: TawkVisitor(
          name: '$displayName $middleName $lastName',
          email: email,
        ),
      ),
    );
  }
}
