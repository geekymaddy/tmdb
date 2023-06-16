import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tmdb/blocs/landing_page/landing_page_bloc.dart';
import 'package:tmdb/helper/route.dart';
import '../constants/strings.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LandingState();
  }
}

class _LandingState extends State<LandingPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LandingPageBloc(),
      child: Scaffold(
        bottomSheet: BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (BuildContext context) {
            return displayBottomSheet(context);
          },
        ),
        body: Container(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget displayBottomSheet(BuildContext context) {
    return BlocListener<LandingPageBloc, LandingPageState>(
      listener: (context, state) {
        if (state is MemberArea) {
          Navigator.push(context, createSignInPageRoute());
        } else if (state is GuestArea) {
          Navigator.pushReplacement(context, createHomePageRoute(false));

        }
      },
      child: BlocBuilder<LandingPageBloc, LandingPageState>(
        builder: (context, state) {
          if (state is ChooseLoginType) {
            return displayBottomSheetChoose(context);
          } else {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              height: 250,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      Strings.getting_started_heading,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const Text(
                      Strings.getting_started,
                      style: TextStyle(
                          fontWeight: FontWeight.normal, color: Colors.black54),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<LandingPageBloc>(context)
                              .add(LandingPageGetStartedButtonTap());
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.red,
                        ),
                        child: const Text(Strings.getting_started_bt,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget displayBottomSheetChoose(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      height: 250,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              Strings.getting_started_start_with,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LandingPageBloc>(context)
                      .add(LandingPageMemberButtonTap());
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    /*overlayColor: MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                      if (states.contains(MaterialState.focused) || states.contains(MaterialState.selected))
                        return Colors.red; //<-- SEE HERE
                      return null; // Defer to the widget's default.
                    },
                  )*/
                    overlayColor: MaterialStateProperty.all<Color>(Colors.red),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Strings.getting_started_member,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(Strings.getting_started_member_desc,
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 80,
              child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<LandingPageBloc>(context)
                      .add(LandingPageGuestButtonTap());
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed) ||
                            states.contains(MaterialState.selected)) {
                          return Colors.red;
                        }
                        return null;
                      },
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black54,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(Strings.getting_started_guest,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        Text(Strings.getting_started_guest_desc,
                            style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Icon(Icons.arrow_forward_ios, color: Colors.black54),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
