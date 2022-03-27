import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vdkFlutterChat/src/core/providers/groupListProvider.dart';
import 'package:vdkFlutterChat/src/core/providers/main_provider.dart';
import '../ContactListScreen/ContactListScreen.dart';
import '../../core/providers/contact_provider.dart';

class ContactListIndex extends StatefulWidget {
  final ContactProvider contactProvider;
  final MainProvider mainProvider;
  final GroupListProvider groupListProvider;
  final refreshList;
  final handlePress;
  const ContactListIndex(
      {Key key,
      this.contactProvider,
      this.mainProvider,
      this.groupListProvider,
      this.refreshList, this.handlePress})
      : super(key: key);

  @override
  _ContactListIndexState createState() => _ContactListIndexState();
}

class _ContactListIndexState extends State<ContactListIndex> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ContactProvider(),
        child: ContactListScreen(
            contactProvider: widget.contactProvider,
            refreshList: widget.refreshList,
            handlePress: widget.handlePress,
            mainProvider: widget.mainProvider,
            groupListProvider: widget.groupListProvider));
  }
}
