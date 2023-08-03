import 'package:dealsproducts/Home.dart';
import 'package:dealsproducts/ProductDetailScreen.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

final FluroRouter router = FluroRouter();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deals 4U Emirates',
      theme: ThemeData.light().copyWith(primaryColor: Colors.blue),
      home: SplashScreen(),
      onGenerateRoute: (settings) {
        if (settings.name!.startsWith('/product/')) {
          // Extract the detail ID from the URL path
          final productId = settings.name!.split('/').last;
          // Navigate to the DetailPage with the extracted detail ID
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => NavigateToDetailPage(detailId: productId),
          );
        }
        // If the route is not recognized, fallback to the home page
        return MaterialPageRoute(
          builder: (context) => ProductListScreen(),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Handle the URL details when the app starts
    _handleInitialUrl(context);

    return Scaffold(
      body: Center(
        child: FlutterLogo(size: 150),
      ),
    );
  }

  // Function to handle the initial URL
  void _handleInitialUrl(BuildContext context) async {
    try {
      String? initialUrl = await getInitialLink();

      if (initialUrl != null) {
        Uri uri = Uri.parse(initialUrl);

        String path = uri.path; // Get the path of the URL (e.g., "/product")

        String? detailId =
            uri.pathSegments.isNotEmpty ? uri.pathSegments[1] : null;

        if (path == '/product' && detailId != null) {
          // Navigate to the detail page with the extracted detail ID
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NavigateToDetailPage(detailId: detailId),
            ),
          );
        } else {
          // Navigate to the home page or handle other cases
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // If no URL details, navigate to the home page
        Navigator.pushReplacementNamed(context, '/home');
      }
    } on PlatformException {
      // Handle error if any
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}
