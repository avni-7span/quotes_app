import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/logout/bloc/logout_bloc.dart';
import 'package:quotes_app/modules/quotes/widgets/logout_alert_dialogue.dart';

class DrawerListViewWidget extends StatelessWidget {
  const DrawerListViewWidget({
    super.key,
  });

  void showDialogue({required BuildContext logoutContext}) {
    showDialog(
      context: logoutContext,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<LogoutBloc>(logoutContext),
          child: const LogoutAlertDialogue(),
        );
      },
    );
  }

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
          onTap: () async {
            await context.router.push(const AdminQuoteListRoute());
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
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            color: Colors.black,
          ),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(),
          child: BlocBuilder<LogoutBloc, LogoutState>(
            builder: (context, state) {
              return BlocListener<LogoutBloc, LogoutState>(
                listener: (context, state) async {
                  if (state.status == LogoutStateStatus.loading) {
                    const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state.status == LogoutStateStatus.success) {
                    await context.router.replaceAll(
                      [const LoginRoute()],
                    );
                  } else if (state.status == LogoutStateStatus.failure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Something went wrong please try again later'),
                      ),
                    );
                  }
                },
                child: ListTile(
                  leading: const Icon(Icons.logout_outlined),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    showDialogue(logoutContext: context);
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
