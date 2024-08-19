import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors/colors.dart';
import 'package:quotes_app/core/routes/router.gr.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/quotes/widgets/drawer_list_view_widget.dart';
import 'package:quotes_app/modules/quotes/widgets/quote_card.dart';

@RoutePage()
class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<QuoteDataBloc, QuoteDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == QuoteStateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong'),
            ),
          );
        }
      },
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: const Text(
              'Be what you want to be',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.white)),
        drawer: const Drawer(
          child: DrawerListViewWidget(),
        ),
        body: Stack(
          children: [
            Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bkg_pic.jpeg'),
                      fit: BoxFit.cover),
                ),
                child: null),
            BlocBuilder<QuoteDataBloc, QuoteDataState>(
              builder: (context, state) {
                return Align(
                    alignment: Alignment.center,
                    child: CarouselSlider(
                      items: List<QuoteCard>.generate(
                        state.listOfQuotes.length,
                        (int) => QuoteCard(index: int),
                      ),
                      options: CarouselOptions(
                          height: size.height - 200,
                          reverse: true,
                          initialPage: 0,
                          enableInfiniteScroll: false),
                    ));
              },
            )
          ],
        ),
        floatingActionButton: BlocBuilder<QuoteDataBloc, QuoteDataState>(
          builder: (context, state) {
            if (state.user.isAdmin!) {
              return SizedBox(
                height: 50,
                child: MaterialButton(
                  color: Colors.black.withOpacity(0.8),
                  onPressed: () {
                    context.router.push(const CreateQuoteRoute());
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.create_outlined,
                        color: ColorPallet.lotusPink,
                      ),
                      Text(
                        '  Create Quote',
                        style: TextStyle(
                            color: ColorPallet.lotusPink, fontSize: 18),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
