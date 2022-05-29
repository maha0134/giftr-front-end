
import "package:flutter/material.dart";

class MyTheme {
  MyTheme();

  static ThemeData buildDark() {
    //final base = ThemeData.dark();

    //ThemeData.from( colorScheme: , textTheme: )
    final ThemeData darkBase = ThemeData.from(
      colorScheme: const ColorScheme(
        //base colour scheme that can be overridden for widgets
        primary: Color.fromARGB(255, 0, 0, 0),
        onPrimary: Color.fromARGB(255, 222, 219, 223),
        secondary: Color.fromARGB(255, 85, 141, 169),
        onSecondary: Colors.lime,
        tertiary: Color.fromARGB(255, 220, 166, 6),
        onTertiary: Colors.lime,

        primaryContainer: Colors.white,
        onPrimaryContainer: Color.fromARGB(255, 243, 0, 0),
        secondaryContainer: Colors.blueAccent,
        onSecondaryContainer: Color.fromARGB(255, 115, 255, 0),
        tertiaryContainer: Colors.blueAccent,
        onTertiaryContainer: Color.fromARGB(255, 110, 2, 118),

        background: Color.fromARGB(255, 255, 255, 255),
        onBackground: Color.fromARGB(255, 0, 0, 0),
        surface: Colors.lightGreen,
        onSurface: Color.fromARGB(255, 110, 2, 118),
        error: Color.fromARGB(255, 197, 122, 201),
        onError: Color.fromARGB(221, 166, 0, 0),

        brightness: Brightness.light, // will switch text between dark/light
        //if colorScheme is light the text will be dark
      ),
      textTheme: const TextTheme(
        //base text theme that can be overridden by widgets
        headline1: TextStyle(
          // letterSpacing: ,
          // fontFamily: ,
          fontSize: 60,
          fontWeight: FontWeight.w700,
        ),
        headline2: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w500,
        ),
        headline3: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w300,
          fontFamily: 'Poppins',
        ),
        headline4: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w300,
        ),
        headline5: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
        headline6: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        bodyText1: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontFamily: 'Poppins',
          color: Colors.white
        ),
        bodyText2: TextStyle(
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w300,
        ),
        subtitle1: TextStyle(
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500,
        ),
        subtitle2: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w300,
          fontFamily: 'Poppins'
        ),
        button: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color: Colors.black
        ),
        caption:TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          fontFamily: 'Poppins',
          color:Color.fromARGB(221, 0, 0, 0) 
        ), 
      ),
    );

    //then build on top of the colorScheme and textTheme
    //to style specific widgets
    ThemeData dark = darkBase.copyWith(
      //colours set in here will override the ColorScheme
      scaffoldBackgroundColor: Color.fromARGB(255, 170, 167, 167),
      shadowColor: Color.fromARGB(207, 0, 0, 0),

      appBarTheme: AppBarTheme(
        backgroundColor: darkBase.colorScheme.onSurface,
        foregroundColor: Color.fromARGB(255, 0,0,0),
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 30,
        ),
        iconTheme: IconThemeData(color: Color.fromARGB(255, 255, 157, 0)),
        //this will override the iconThemeData
      ),

      iconTheme: IconThemeData(
        //defaults for icons unless overridden
        color: darkBase.colorScheme.primary,
        size: 36,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: darkBase.colorScheme.onSurface,
        foregroundColor: Colors.white, //for the icon
        elevation: 20, //for all FABs
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 17, 205, 205)),
          foregroundColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 0, 0, 0)),
          elevation: MaterialStateProperty.all(10), //for all ElevatedButtons
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.purple),
        ),
      ),

      cardTheme: const CardTheme(
        color: Color.fromARGB(255, 0, 255, 128), //background of card
        elevation: 12, //shadow distance, z-index for all cards
        //to change the rounding of the corners use shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.all(15),
        tileColor: darkBase.colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(7))
        ),
        textColor: Colors.black,
        style: ListTileStyle.list,
        dense: false,
        iconColor: darkBase.colorScheme.onTertiaryContainer,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 27, 27, 27), width: 2.0),),
        errorStyle: darkBase.textTheme.caption,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: darkBase.colorScheme.error, width: 2.0),),
        labelStyle: const TextStyle(
          color: Color.fromARGB(255, 81, 27, 86)
        ),
        hintStyle: const TextStyle(
          color: Color.fromARGB(255, 45, 45, 45)
        )
      ),
    );

    return dark;
  }

  // static ThemeData buildLight() {
  // ThemeData lightBase = ThemeData.from(
  //   colorScheme: ColorScheme(),
  //   textTheme: TextTheme(),
  // );
  // ThemeData light = lightBase.copyWith(
  //
  // );
  //
  // return light;
  // }
}
