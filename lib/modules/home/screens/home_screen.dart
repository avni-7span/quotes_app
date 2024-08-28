import 'package:auto_route/auto_route.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quotes_app/core/constants/colors.dart';
import 'package:quotes_app/core/routes/router/router.gr.dart';
import 'package:quotes_app/modules/home/bloc/quote_data_bloc.dart';
import 'package:quotes_app/modules/home/widgets/bottom_sheet_widget.dart';
import 'package:quotes_app/modules/home/widgets/drawer_list_view_widget.dart';
import 'package:quotes_app/modules/home/widgets/quote_card.dart';
import 'package:screenshot/screenshot.dart';

@RoutePage()
class HomeScreen extends StatefulWidget implements AutoRouteWrapper {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteBloc()
        ..add(const FetchQuoteDataEvent())
        ..add(const FetchAdminDetailEvent()),
      child: this,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  final bool isFavourite = false;

  Future _showBottomSheet(BuildContext sheetContext) {
    return showModalBottomSheet(
      context: sheetContext,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (context) {
        return BlocProvider.value(
          value: BlocProvider.of<QuoteBloc>(sheetContext),
          child: BottomSheetWidget(
            screenshotController: _screenshotController,
            // isFavourite: isFavourite,
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
    return BlocListener<QuoteBloc, QuoteState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.apiStatus != current.apiStatus,
      listener: (context, state) {
        if (state.apiStatus == APIStatus.error) {
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
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Quote copied to clipboard.',
              ),
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
            BlocBuilder<QuoteBloc, QuoteState>(
              builder: (context, state) {
                return Align(
                  alignment: Alignment.center,
                  child: CarouselSlider(
                    items: List<QuoteCard>.generate(
                      state.quoteList.length,
                      (index) {
                        return QuoteCard(index: index);
                      },
                    ),
                    options: CarouselOptions(
                      height: size.height - 200,
                      reverse: true,
                      initialPage: 0,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, _) {
                        context
                            .read<QuoteBloc>()
                            .add(CurrentIndexChangeEvent(index: index));
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
        floatingActionButton: BlocBuilder<QuoteBloc, QuoteState>(
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
