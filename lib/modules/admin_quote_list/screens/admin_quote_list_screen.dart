import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors/colors.dart';
import 'package:quotes_app/modules/admin_quote_list/bloc/admin_quote_list_bloc.dart';

@RoutePage()
class AdminQuoteListScreen extends StatelessWidget {
  const AdminQuoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) =>
          AdminQuoteListBloc()..add(const FetchingAdminQuoteListEvent()),
      child: Scaffold(
        backgroundColor: ColorPallet.blurGreen,
        appBar: AppBar(
          title: const Text(
            'My Quotes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: ColorPallet.lotusPink,
        ),
        body: BlocListener<AdminQuoteListBloc, AdminQuoteListState>(
          listener: (context, state) {
            if (state.status == AdminQuoteListStateStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.error ?? ''),
                ),
              );
            }
          },
          child: BlocBuilder<AdminQuoteListBloc, AdminQuoteListState>(
            builder: (context, state) {
              return Center(
                  child: state.status == AdminQuoteListStateStatus.fetching
                      ? const CircularProgressIndicator()
                      : state.status == AdminQuoteListStateStatus.loaded
                          ? ListView.builder(
                              itemCount: state.listOfAdminQuotes.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  height: size.height * (0.25),
                                  child: Card(
                                    margin: const EdgeInsets.all(15),
                                    shadowColor: Colors.black,
                                    color: Colors.white,
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            state.listOfAdminQuotes[index]
                                                    .quote ??
                                                '',
                                            style:
                                                const TextStyle(fontSize: 20),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            '- ${state.listOfAdminQuotes[index].author}',
                                            style:
                                                const TextStyle(fontSize: 20),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Text('No Data'));
            },
          ),
        ),
      ),
    );
  }
}
