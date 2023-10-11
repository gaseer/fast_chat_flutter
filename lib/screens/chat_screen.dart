import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fast_chat_flutter/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

late User logUser;

class ChatScreen extends StatefulWidget {
  static const id = 'Chat';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  final txtCon = TextEditingController();
  late String masg;
  final _firestore = FirebaseFirestore.instance;

  final _auth = FirebaseAuth.instance;

  
  void getUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        logUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  void msgStream() async {
    await for (var snp in _firestore.collection('msg').snapshots()) {
      for (var message in snp.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                msgStream();
                // _auth.signOut();
                // Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('msg').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: SpinKitCubeGrid(
                        color: Colors.teal,
                        size: 100.0,
                      ),
                    );
                  }
                  final msgs = snapshot.data?.docs.reversed;
                  List<msgB> msgWid = [];
                  for (var msg in msgs!) {
                    final data = msg.data() as Map;
                    final mTx = data['text'];
                    final mSe = data['sender'];

                    final curuser = logUser.email;

                    final msWd = msgB(
                      sen: mSe,
                      ms: mTx,
                      isMe: curuser == mSe,
                    );
                    msgWid.add(msWd);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
                      children: msgWid,
                    ),
                  );
                }),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: txtCon,
                      onChanged: (value) {
                        masg = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      txtCon.clear();
                      _firestore.collection('msg').add({
                        'sender': logUser.email,
                        'text': masg,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class msgB extends StatelessWidget {
  msgB({required this.sen, required this.ms, required this.isMe});
  final String? sen;
  final String? ms;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sen",
            style: TextStyle(fontSize: 12.0, color: Colors.black87),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
            elevation: 15.0,
            color: isMe ? Colors.blueAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: Text(
                '$ms',
                style: isMe
                    ? TextStyle(fontSize: 20.0, color: Colors.white)
                    : TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
