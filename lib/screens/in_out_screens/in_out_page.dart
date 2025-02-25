import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class InOutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
          children: [
            Consumer<UserProvider>(
              builder: (context, userNotifer, child) {
                return Text('${userNotifer.pemail}');
              },
            )
          ],
        )
    );
  }
}
