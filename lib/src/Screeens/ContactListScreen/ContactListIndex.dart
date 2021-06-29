import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../ContactListScreen/ContactListScreen.dart';
import '../../core/providers/contact_provider.dart';

class ContactListIndex extends StatefulWidget {
  const ContactListIndex({Key key}) : super(key: key);

  @override
  _ContactListIndexState createState() => _ContactListIndexState();
}

class _ContactListIndexState extends State<ContactListIndex> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => ContactProvider(), child: ContactListScreen());
    
  }
}