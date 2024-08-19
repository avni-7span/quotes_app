import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:quotes_app/core/constants/colors/colors.dart';
import 'package:quotes_app/core/routes/router.gr.dart';

class DrawerListViewWidget extends StatelessWidget {
  const DrawerListViewWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: ColorPallet.teanGreen),
          child: null,
        ),
        ListTile(
          leading: const Icon(Icons.file_copy_outlined),
          title: const Text(
            'My Quotes',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {
            context.router.push(const AdminQuoteListRoute());
          },
        ),
        ListTile(
          leading: const Icon(Icons.bookmark_outlined),
          title: const Text(
            'Bookmarks',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.search),
          title: const Text(
            'Search Categories',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black),
          ),
          onTap: () {},
        )
      ],
    );
  }
}
