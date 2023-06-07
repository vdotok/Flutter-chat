import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/auth.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import '../CreateGroupScreen/CreateGroupChatScreen.dart';
import '../../core/providers/contact_provider.dart';

class CreateGroupChatIndex extends StatefulWidget {
  final ContactProvider contactProvider;
  final MainProvider mainProvider;
  final GroupListProvider? groupListProvider;
  final AuthProvider? authProvider;
  final refreshList;
  final handlePress;
  const CreateGroupChatIndex(
      {Key? key,
      required this.contactProvider,
      required this.mainProvider,
      this.groupListProvider,
      this.refreshList,
      this.handlePress, this.authProvider})
      : super(key: key);

  @override
  _CreateGroupChatIndexState createState() => _CreateGroupChatIndexState();
}

class _CreateGroupChatIndexState extends State<CreateGroupChatIndex> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ContactProvider>(
            create: (context) => ContactProvider(),
          ),
        ],
        child: CreateGroupChatScreen(
          authProvider: widget.authProvider,
            contactProvider: widget.contactProvider,
            refreshList: widget.refreshList,
            handlePress: widget.handlePress,
            mainProvider: widget.mainProvider,
            groupListProvider: widget.groupListProvider));
  }
}
