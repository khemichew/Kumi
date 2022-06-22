import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

// ********** Text Styles **********

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

const TextStyle cardNameStyle =
TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle smallStyle =
TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle hugeStyle =
TextStyle(fontSize: 50, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle filterStyle =
TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black);

const TextStyle ordinaryWhiteStyle =
TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white);


// ********** Colors **********

const skyBlue = Color.fromRGBO(173, 190, 216, 1.0);
const champaignGold = Color.fromRGBO(255, 229, 205, 1.0);
const mintGreen = Color.fromRGBO(53, 219, 169, 1.0);
const honeyOrange = Color.fromRGBO(255, 191, 0, 0.5);
const navyBlue = Color.fromRGBO(51, 85, 135, 1.0);


// ********** Background **********

const BoxDecoration gradientBackground = BoxDecoration(
    gradient: LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  colors: [
    skyBlue,
    champaignGold,
  ],
));


// ********** Button Styles **********

final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  primary: Colors.black87,
  minimumSize: const Size(88, 36),
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2.0)),
  ),
);

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

// ********** Border Radii **********

var regularRadius = BorderRadius.circular(10.0);


// ********** Border Radii **********

const verticalTenInsets = EdgeInsets.symmetric(vertical: 0.0, horizontal: 10.0);
const horizontalTenInsets = EdgeInsets.symmetric(vertical: 10.0, horizontal: 0.0);
const allSidesTenInsets = EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0);



// ********** Shadow **********

const defaultBoxShadow = [
  BoxShadow(color: Colors.black, offset: Offset(0, 5), blurRadius: 5),
];


// ********** Page Decoration **********

const pageDecoration = BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        skyBlue,
        champaignGold,
      ],
    ));


// ********** Spacing **********

const standardSpacing = SizedBox(height: 50, width: 50);
const halfSpacing = SizedBox(height: 25, width: 25);
const quadSpacing = SizedBox(height: 12, width: 12);


// ********** Misc **********

final errorBorder = UnderlineInputBorder(
  borderRadius: BorderRadius.circular(6.0),
  borderSide: const BorderSide(
    color: Colors.red,
  ),
);

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/config.json');
}

final Map<String, String> appIdMap = {'nectar': '(299)'};
