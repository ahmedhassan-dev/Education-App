import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        height: (MediaQuery.of(context).size.height / 3.8),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 68, 31, 1),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(220), topRight: Radius.circular(220))),
      ),
      Positioned(
        bottom: (MediaQuery.of(context).size.height / 3.8) - 20,
        child: SizedBox(
            height: 40,
            child: Expanded(
              child:
                  Hero(tag: "heroTag", child: Image.asset("assets/logo.jpg")),
            )),
      ),
      Positioned(
          bottom: 70,
          child: GestureDetector(
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) {
            //         return const HeroDetailPage();
            //       },
            //     ),
            //   );
            // },
            child: const Text(
              "Let's Start",
              textDirection: TextDirection.ltr,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ))
    ]);
  }
}
