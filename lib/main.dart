import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:translate_test/locale_provider.dart';
import 'package:translate_test/map_page.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => LocaleProvider())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocaleProvider localeProvider = context.watch();

    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        AppLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      locale: localeProvider.currentLocale,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ScrollController scrollController = ScrollController();

  mylistener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.position.pixels >
          scrollController.position.maxScrollExtent) {
        scrollController.animateTo(0,
            duration: const Duration(seconds: 9), curve: Curves.linear);
      } else if (scrollController.position.pixels == 0) {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 9), curve: Curves.linear);
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(const Duration(seconds: 3), () {
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: const Duration(seconds: 9), curve: Curves.linear);
      });
    });

    scrollController.addListener(mylistener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(mylistener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> toMarquesine =
        AppLocalizations.of(context).toProof.replaceAll("'", "").split(" ");

    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        // final double maxExtend = scrollController.position.maxScrollExtent;
        // scrollController.animateTo(maxExtend,
        //     duration: const Duration(seconds: 3), curve: Curves.linear);
      }),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context).appTitle),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context).centerText),
            const SizedBox(height: 10),
            Text(AppLocalizations.of(context).toProof),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (_, index) =>
                    Text("${[" ", ...toMarquesine, " "][index]} "),
                itemCount: [" ", ...toMarquesine, " "].length,
                scrollDirection: Axis.horizontal,
                controller: scrollController,
              ),
            ),

            // SizedBox(
            //   width: MediaQuery.of(context).size.width,
            //   height: 50,
            //   child: ListView.builder(
            //     physics: const NeverScrollableScrollPhysics(),
            //     itemBuilder: (_, index) => Text("${["Hola", "mundo"][index]} "),
            //     itemCount: ["Hola", "mundo"].length,
            //     scrollDirection: Axis.horizontal,
            //     controller: scrollController,
            //   ),
            // ),

            ElevatedButton(
                onPressed: () =>
                    context.read<LocaleProvider>().updateCurrentLocale("en"),
                child: const Text("Change Language to EN")),
            ElevatedButton(
                onPressed: () =>
                    context.read<LocaleProvider>().updateCurrentLocale("es"),
                child: const Text("Cambiar lenguaje a ES")),
            ElevatedButton(
                onPressed: () {
                  showDateRangePicker(
                      context: context,
                      locale: context.read<LocaleProvider>().currentLocale,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 10)));
                },
                child: const Text("Abrir el datePicker")),
            ElevatedButton(
                onPressed: () => Navigator.of(context)
                    .push(CupertinoPageRoute(builder: (_) => const MapPage())),
                child: const Text("Ir al mapa"))
          ],
        ),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  String text = "text";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            text += "text";
          });
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: LayoutBuilder(
          builder: (ctx, constraints) {
            final style = Theme.of(context).textTheme.headline1;
            final span = TextSpan(
              text: text,
              style: style,
            );
            final painter = TextPainter(
              text: span,
              maxLines: 1,
              textScaleFactor: MediaQuery.of(context).textScaleFactor,
              textDirection: TextDirection.ltr,
            );
            painter.layout();
            final overflow = painter.size.width > constraints.maxWidth;
            return Container(
              color: overflow ? Colors.red : Colors.green,
              child: Text.rich(span, style: style),
            );
          },
        ),
      ),
    );
  }
}
