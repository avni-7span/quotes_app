import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/modules/admin_quote_list/bloc/admin_quote_list_bloc.dart';

class AdminQuoteListScreen extends StatelessWidget {
  const AdminQuoteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          AdminQuoteListBloc()..add(const FetchingAdminQuoteListEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Quotes',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.blueAccent.shade100,
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
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : state.status == AdminQuoteListStateStatus.loaded
                          ? ListView.builder(
                              itemCount: state.listOfAdminQuotes.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      state.listOfAdminQuotes[index].quote ??
                                          ''),
                                  subtitle: Text(
                                      state.listOfAdminQuotes[index].author ??
                                          ''),
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
