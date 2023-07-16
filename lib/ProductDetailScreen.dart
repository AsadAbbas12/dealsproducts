import 'dart:async';
import 'dart:convert'; // Add this import statement at the top

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Product.dart';
import 'list/ProductList.dart';
// import 'dart:js' as js;

String baseUrl =
    "https://www.projects.xiico.net/asad-abbas/flutter-pms-api/public/";

String name = '';
String selectedEmirate = 'Dubai'; // Set initial value
String phoneNumber = '';
String address = '';
String notes = '';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class NameTextField extends StatefulWidget {
  @override
  _NameTextFieldState createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          name = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Name *',
        hintText: 'Enter your name',
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

class PhoneNumberTextField extends StatefulWidget {
  @override
  _PhoneNumberTextFieldState createState() => _PhoneNumberTextFieldState();
}

class _PhoneNumberTextFieldState extends State<PhoneNumberTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          phoneNumber = value;
        });
      },

      decoration: InputDecoration(
        labelText: 'Phone Number *',
        hintText: 'Enter your phone number',
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      keyboardType: TextInputType.phone, // Set the input type to phone number
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ], // Set the input type to phone number
    );
  }
}

class AddressTextField extends StatefulWidget {
  @override
  _AddressTextFieldState createState() => _AddressTextFieldState();
}

class _AddressTextFieldState extends State<AddressTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          address = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Address *',
        hintText: 'Enter your Address',
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLines: 3, // Allow multiple lines for the address
    );
  }
}

class NotesTextField extends StatefulWidget {
  @override
  _NotesTextFieldState createState() => _NotesTextFieldState();
}

class _NotesTextFieldState extends State<NotesTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {
          notes = value;
        });
      },
      decoration: InputDecoration(
        labelText: 'Notes',
        hintText: 'Write instructions or your choice for us (Optional)',
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLines: 3, // Allow multiple lines for the notes
    );
  }
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isPlacingOrder = false;
  final CarouselController _carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    // // Call the Facebook Pixel code when the detail page is built
    //  js.context.callMethod('fbq', ['track', 'ViewContent']);

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        titleSpacing: -40.0,
        // Adjust the value as needed// Remove the back button
        title: GestureDetector(
          onTap: () async {
            if (kIsWeb) {
              const url = 'https://www.deals4u.ae';
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw 'Could not launch $url';
              }
            } else {
              Navigator.pop(context);
            }
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to the left
              children: [
                Align(
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
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Stack(
                children: [
                  CarouselSlider(
                    carouselController: _carouselController,
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.4,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        // Handle the page change event
                        // This can be used to update the current image index or perform any other actions
                      },
                    ),
                    items: widget.product.images.map((image) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: InteractiveViewer(
                                  panEnabled: false,
                                  minScale: 0.1,
                                  maxScale: 3.0,
                                  child: CachedNetworkImage(
                                    imageUrl: baseUrl + image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: baseUrl + image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        // Example attractive background color: pink
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Free Delivery",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
            SizedBox(height: 16.0),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product.images.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _carouselController.animateToPage(index);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: CachedNetworkImage(
                        imageUrl: baseUrl + widget.product.images[index],
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: Container(
                            color: Colors.white,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.product.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.product.price.toString() + " AED",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      if (widget.product.discountPercentage >
                          0.0) // Display discount only if it's greater than 0
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            // Example attractive background color: yellowAccent
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.3),
                                // Example shiny effect color: yellowAccent with opacity
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Discount: ${widget.product.discountPercentage}%",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 0.0),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        'Product Description',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Text(
                          widget.product.description.toString(),
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.product.description.toString(),
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NameTextField(),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: DropdownButtonFormField<String>(
                value: selectedEmirate,
                onChanged: (value) {
                  setState(() {
                    selectedEmirate = value!;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Region',
                  hintText: 'Select your region',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                items: [
                  DropdownMenuItem<String>(
                    value: 'Abu Dhabi',
                    child: Text('Abu Dhabi'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Dubai',
                    child: Text('Dubai'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Sharjah',
                    child: Text('Sharjah'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Ajman',
                    child: Text('Ajman'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Fujairah',
                    child: Text('Fujairah'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'Umm Al-Quwain',
                    child: Text('Umm Al-Quwain'),
                  ),
                  // Add more Emirates' names here
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PhoneNumberTextField(),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AddressTextField(),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NotesTextField(),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Quantity:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                if (_quantity >= 2) _quantity--;
                              });
                            },
                            child: Icon(Icons.remove),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(16.0),
                            ),
                          ),
                          SizedBox(width: 6.0),
                          Text(
                            _quantity.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          SizedBox(width: 6.0),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            child: Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              shape: CircleBorder(),
                              padding: EdgeInsets.all(16.0),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0),
                  // Add some vertical spacing between the buttons and the total price
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Total Price: AED ${_quantity * widget.product.price}',
                      // Replace 'widget.product.price' with your actual price calculation logic
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isPlacingOrder = true;
                      });
                      _placeOrder(
                        name.toString(),
                        selectedEmirate.toString(),
                        phoneNumber.toString(),
                        address.toString(),
                        widget.product.title.toString(),
                        widget.product.price.toString(),
                        _quantity.toString(),
                        "Deals4U -> " + notes,
                        context,
                        _isPlacingOrder,
                      );
                    },
                    child: Text('Place Order'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
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
    );
  }

  void _launchWhatsApp() async {
    String message = 'Hi, I am interested in your products , Name :' +
        widget.product.title +
        " Price : " +
        widget.product.price.toString();
    String url = 'https://wa.me/+971523801390?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class GridView extends StatefulWidget {
  @override
  _ProductListScreenStateDetail createState() =>
      _ProductListScreenStateDetail();
}

class _ProductListScreenStateDetail extends State<GridView> {
  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductService.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
      ),
      child: Stack(
        children: [
          Center(
            child: FutureBuilder<List<Product>>(
              future: _futureProducts,
              builder: (BuildContext context,
                  AsyncSnapshot<List<Product>> snapshot) {
                if (snapshot.hasData) {
                  return ProductList(products: snapshot.data!!);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

void _placeOrder(
  String name,
  String selectedEmirates,
  String phoneNumber,
  String address,
  productName,
  price,
  quantity,
  notes,
  context,
  bool isPlacingOrder,
) async {
  if (notes.isEmpty) {
    notes = 'empty';
  }

  if (name.isEmpty || phoneNumber.isEmpty || address.isEmpty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Your Order Details'),
          content: Text('Please fill in required(*) fields.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
    return;
  }

  bool confirmed = await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Order'),
        content: Text.rich(
          TextSpan(
            children: [
              const TextSpan(
                text:
                    'Are you sure you want to place the order on this number:\n',
              ),
              TextSpan(
                text: phoneNumber,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(
                text: '?',
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceled
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceled
            },
            child: Text('Change Number'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirmed
            },
            child: Text('Confirm'),
          ),
        ],
      );
    },
  );

  if (!confirmed) {
    return;
  }

  String url =
      'https://projects.xiico.net/asad-abbas/flutter-pms-api/public/api/create_order';

  String apiKey =
      'ZWRWOfQNMIEZP8dEPuNE3oV7VTFYgfA3lSisVICo3h61m0ePZMdzD1bmmQbp';

  Map<String, String> headers = {'API-Key': apiKey};

  Map<String, String> params = {
    'customer_name': name,
    'phone': phoneNumber,
    'email': "Empty@gmail.com",
    'product_name': productName,
    'quantity': quantity.toString(),
    'price': price.toString(),
    'shipping_address': address + " ," + selectedEmirates,
    'customer_notes': notes,
  };

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20.0),
                Text('Placing order...'),
              ],
            ),
          ),
        ),
      );
    },
  );

  try {
    // Send the HTTP POST request
    var response = await http.post(
      Uri.parse(url),
      body: params,
      headers: headers,
    );

    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      // Parse the response JSON
      var responseData = json.decode(response.body);
      bool status = responseData['status'];
      String message = responseData['message'];

      if (status) {
        String successMessage =
            'Thank you for placing your order! We have received it successfully and are thrilled to serve you. Our dedicated team is committed to delivering your order within the next 24 hours';
        // Success: Show pop-up
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(productName),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(successMessage),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Error: Show pop-up
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 64.0,
                  ),
                  SizedBox(height: 16.0),
                  Text(message),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // Error: Show pop-up
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 64.0,
                ),
                SizedBox(height: 16.0),
                Text('Failed to place the order.'),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  } catch (error) {
    print('Error: $error');
    Navigator.of(context, rootNavigator: true).pop();
  }
}
