
import "package:flutter/material.dart";

class MyTheme {
  MyTheme();

  static ThemeData buildDark() {
    final ThemeData darkBase = ThemeData.from(
      colorScheme: const ColorScheme(
        primary: Color.fromARGB(255, 110, 2, 118),
        onPrimary: Color.fromARGB(255, 222, 219, 223),
        secondary: Color.fromARGB(255, 185, 187, 188),
        onSecondary: Color.fromARGB(255, 182, 138, 167),
        tertiary: Color.fromARGB(255, 220, 166, 6),
        onTertiary: Color.fromARGB(255, 200, 164, 212),

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
        headline1: TextStyle(
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

    
    ThemeData dark = darkBase.copyWith(
      scaffoldBackgroundColor: const Color.fromARGB(255, 170, 167, 167),
      shadowColor: const Color.fromARGB(207, 0, 0, 0),

      appBarTheme: AppBarTheme(
        backgroundColor: darkBase.colorScheme.onSurface,
        foregroundColor: const Color.fromARGB(255, 0,0,0),
        titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
          fontSize: 30,
        ),
        iconTheme: const IconThemeData(color: Color.fromARGB(255, 255, 157, 0)),
      ),

      iconTheme: IconThemeData(
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
          backgroundColor: MaterialStateProperty.all<Color>(darkBase.colorScheme.onTertiaryContainer),
          foregroundColor: MaterialStateProperty.all<Color>(darkBase.colorScheme.background),
          elevation: MaterialStateProperty.all(10), //for all ElevatedButtons
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(darkBase.colorScheme.primary),
        ),
      ),

      cardTheme: const CardTheme(
        color: Color.fromARGB(255, 0, 255, 128), //background of card
        elevation: 12, //shadow distance, z-index for all cards
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        margin: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 0,
        ),
      ),

      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.all(10),
        tileColor: darkBase.colorScheme.onPrimary,
        shape:  const RoundedRectangleBorder(
          side: BorderSide(width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5))
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
        labelStyle: TextStyle(
          color: darkBase.colorScheme.onTertiaryContainer,
        ),
        hintStyle: TextStyle(
          color: darkBase.colorScheme.onPrimary,
        ),
        prefixStyle: TextStyle(
          color: darkBase.colorScheme.primary,
          fontSize: 25,
        ),
      ),
    );

    return dark;
  }
}
