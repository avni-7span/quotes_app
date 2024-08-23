import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/quotes/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/quotes/widgets/bottom_sheet_widget.dart';
import 'package:quotes_app/modules/quotes/widgets/drawer_list_view_widget.dart';
import 'package:quotes_app/modules/quotes/widgets/quote_card.dart';
import 'package:screenshot/screenshot.dart';

@RoutePage()
class QuoteScreen extends StatefulWidget implements AutoRouteWrapper {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteDataBloc()
        ..add(const FetchQuoteDataEvent())
        ..add(const FetchAdminDetailEvent()),
      child: this,
    );
  }
}

class _QuoteScreenState extends State<QuoteScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  Future _showBottomSheet(BuildContext sheetContext) {
    return showModalBottomSheet(
      context: sheetContext,
      useRootNavigator: true,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<QuoteDataBloc>(sheetContext),
          child: BottomSheetWidget(
            screenshotController: _screenshotController,
            onClosedTap: () {
              Navigator.pop(sheetContext);
              // Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<QuoteDataBloc, QuoteDataState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == QuoteStateStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Something went wrong.'),
            ),
          );
          return;
        }
        if (state.status == QuoteStateStatus.copiedSuccessfully) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Quote copied to clipboard.'),
            ),
          );
          return;
        }
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            title: const Text(
              'Be What You Want To Be',
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
                      (int) {
                        return QuoteCard(index: int);
                      },
                    ),
                    options: CarouselOptions(
                      height: size.height - 200,
                      reverse: true,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, _) {
                        context
                            .read<QuoteDataBloc>()
                            .add(CurrentIndexChangeEvent(index: index));
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: BlocBuilder<QuoteDataBloc, QuoteDataState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 60,
                    width: 60,
                    child: MaterialButton(
                      color: Colors.black.withOpacity(0.8),
                      onPressed: () {
                        _showBottomSheet(context);
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.more_vert,
                        size: 30,
                        color: ColorPallet.lotusPink,
                      ),
                    ),
                  ),
                  if (state.user.isAdmin!)
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: MaterialButton(
                        color: Colors.black.withOpacity(0.8),
                        onPressed: () async {
                          await context.router.push(const CreateQuoteRoute());
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.add,
                          size: 30,
                          color: ColorPallet.lotusPink,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
