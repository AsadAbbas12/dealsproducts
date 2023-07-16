import 'dart:async';

import 'package:dealsproducts/list/ProductList.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Product.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Call the function to pre-cache assets
  runApp(MyApp());
}

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.getProducts();
  }

  void _launchWhatsApp() async {
    String message =
        'Hello, I am interested in your product. Please send me more information.';
    String url = 'https://wa.me/+971523801390?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverFillRemaining(
                child: Center(
                  child: FutureBuilder<List<Product>>(
                    future: _futureProducts,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Product>> snapshot) {
                      if (snapshot.hasData) {
                        return ProductList(products: snapshot.data!);
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Tooltip(
        message:
            'Contact us on WhatsApp and inquire about our latest sale offers.',
        child: FloatingActionButton(
          onPressed: _launchWhatsApp,
          backgroundColor: Colors.transparent,
          child: Image.asset(
            'assets/whatsapp.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[700]!, Colors.blue[900]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '© 2023 ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                        TextSpan(
                          text: 'Deals 4U Emirates',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = 'https://www.deals4u.ae';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                        ),
                        TextSpan(
                          text: '. All Rights Reserved.',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the Play Store
                    },
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: Image.asset(
                        'assets/play.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      // Navigate to the App Store
                    },
                    child: SizedBox(
                      height: 18,
                      width: 18,
                      child: Image.asset(
                        'assets/apple.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.lock, size: 18, color: Colors.white),
                ],
              )),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {



  void _launchWhatsAppCatalogue() async {
    String url = 'https://wa.me/c/971523801390';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Deals 4U UAE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[600],
          centerTitle: true,
          elevation: 0.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(0),
            ),
          ),
          title: Container(
            margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to the left
              children: [
                GestureDetector(
                  onTap: () async {
                    const url = 'https://www.deals4u.ae';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Icon(
                          Icons.shopping_cart_rounded,
                          size: 24.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 8.0),
                        Text(
                          'Deals 4U Emirates',
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '          E - C O M M E R C E  S T O R E',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: 'Pacifico',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
              onTap: () {
                _launchWhatsAppCatalogue();
                //showToast();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0), // Set the border radius for rounded corners
                  color: Colors.transparent, // Set the background color for the container
                ),
                child: Row(
                  children: [
                    Text(
                      'On Whatsapp', // Add your desired text here
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_business_sharp),
                      color: Colors.green[900],
                      onPressed: () {
                        _launchWhatsAppCatalogue();
                        //showToast();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],


        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Container(
                color: Colors.blue[100],
                // set a bluish tint as the background color
                child: ProductListScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast() {
    Fluttertoast.showToast(
      msg:
          "The website is secure but also highly trustable, providing a reliable and safe browsing experience for its users. ",
      toastLength: Toast.LENGTH_LONG,
      // Increase the duration
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
      timeInSecForIosWeb: 5, // Specify the duration in seconds
    );
  }
}
