import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../CreateGroupScreen/CreateGroupChatScreen.dart';
import '../../core/providers/contact_provider.dart';

class CreateGroupChatIndex extends StatefulWidget {
  const CreateGroupChatIndex({Key key}) : super(key: key);

  @override
  _CreateGroupChatIndexState createState() => _CreateGroupChatIndexState();
}

class _CreateGroupChatIndexState extends State<CreateGroupChatIndex> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [
      ChangeNotifierProvider<ContactProvider>(
        create: (context) => ContactProvider(),
      ),
    ], child: CreateGroupChatScreen());
  }
}
