import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

const TextStyle titleStyle =
    TextStyle(fontSize: 23, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle emphStyle =
    TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black);

const TextStyle largeTitleStyle =
    TextStyle(fontSize: 32, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle smallOptTextStyle =
    TextStyle(fontSize: 9.5, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle ordinaryStyle =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black);

const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    Color.fromRGBO(173, 190, 216, 1),
    Color.fromRGBO(255, 229, 205, 1),
  ],
));

const TextStyle smallStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle hugeStyle =
    TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle filterStyle =
    TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black);

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
    primary: Colors.black87,
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
    ),
);

const TextStyle ordinaryWhiteStyle =
TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);

const defaultBoxShadow = [
    BoxShadow(
        color: Colors.black,
        offset: Offset(0, 5),
        blurRadius: 5
    ),
];

final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
    primary: Colors.black87,
    minimumSize: const Size(80, 36),
    padding: const EdgeInsets.symmetric(horizontal: 5),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(3)),
    ),
).copyWith(
    side: MaterialStateProperty.resolveWith<BorderSide>(
            (Set<MaterialState> states) {
            if (states.contains(MaterialState.pressed)) {
              return const BorderSide(
                    color: Colors.amberAccent,
                    width: 1,
                    style: BorderStyle.solid,
                );
            }
            return const BorderSide(); // Defer to the widget's default.
        },
    ),
);

final ButtonStyle smallOptStyle = OutlinedButton.styleFrom(
  primary: Colors.black12,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
  ),
).copyWith(
  side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return const BorderSide(
          color: Colors.amberAccent,
          width: 1,
          style: BorderStyle.solid,
        );
      }
      return const BorderSide(); // Defer to the widget's default.
    },
  ),
);

Future<String> loadAsset() async {
    return await rootBundle.loadString('assets/config.json');
}

final Map<String, String> appIdMap = {
    'nectar': '(299)'
};
