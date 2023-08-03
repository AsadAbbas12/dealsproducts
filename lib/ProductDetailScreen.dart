import 'dart:convert'; // Add this import statement at the top
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dealsproducts/list/model/ProductModelDetail.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'list/model/ProductModel.dart';

String baseUrl = "https://uaedeals4u.ae/admin/api/public/";

String name = '';
String selectedEmirate = 'Dubai'; // Set initial value
String phoneNumber = '';
String address = '';
String notes = '';

class ProductDetailScreen extends StatefulWidget {
  late final ProductModelDetail? product;

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
      decoration: const InputDecoration(
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

      decoration: const InputDecoration(
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
      decoration: const InputDecoration(
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
      decoration: const InputDecoration(
        labelText: 'Notes',
        hintText: 'Write instructions or your choice for us (Optional)',
        border: OutlineInputBorder(),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
      maxLines: 3, // Allow multiple lines for the notes
    );
  }
}

int _currentIndex = 0; // Initialize _currentIndex variable

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isPlacingOrder = false;
  final CarouselController _carouselController = CarouselController();

  ProductModelDetail? productModel = null;

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
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        titleSpacing: -40.0,
        // Adjust the value as needed// Remove the back button
        title: GestureDetector(
          onTap: () async {
            // if (kIsWeb) {
            //   const url = 'https://www.uaedeals4u.ae';
            //   if (await canLaunch(url)) {
            //     await launch(url);
            //   } else {
            //     throw 'Could not launch $url';
            //   }
            // } else {
            Navigator.pop(context);
            //  }
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16.0, top: 16.0),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align text to the left
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back,
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_business_sharp),
            color: Colors.white,
            onPressed: () {
              _launchWhatsAppCatalogue();
              //showToast();
            },
          ),
        ],
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
                        setState(() {
                          _currentIndex =
                              index; // Update _currentIndex on page change
                        });
                      },
                    ),
                    items: widget.product?.images.map((image) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AlertDialogFullScreen(
                                carouselController: _carouselController,
                                images: widget.product!.images,
                                baseUrl: baseUrl,
                                initialIndex: _currentIndex,
                              ),
                            ),
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
                              const Icon(Icons.error),
                        ),
                      );
                    }).toList(),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.pink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
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
            const SizedBox(height: 16.0),
            Container(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.product!.images.length,
                itemBuilder: (context, index) {
                  bool isSelected = (index == _currentIndex);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex =
                            index; // Update _currentIndex on image selection
                      });
                      _carouselController.animateToPage(index);
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.blue : Colors.transparent,
                          width: isSelected ? 2.0 : 0.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: baseUrl + widget.product!.images[index],
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
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
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
                      widget.product!.productTitle,
                      style: const TextStyle(
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
                        widget.product!.price.toString() + " AED",
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            TextSpan(
                              text: (widget.product!.price +
                                          (widget.product!.price *
                                              (widget.product!
                                                      .discountPercentage /
                                                  100)))
                                      .toStringAsFixed(2) +
                                  " AED",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (widget.product!.discountPercentage >
                          0.0) // Display discount only if it's greater than 0
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
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
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Text(
                            "Discount: ${widget.product!.discountPercentage}%",
                            style: const TextStyle(
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
            const SizedBox(height: 0.0),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Product Description',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: SingleChildScrollView(
                        child: Text(
                          widget.product!.description.toString(),
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  widget.product!.description.toString(),
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NameTextField(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16.0),
                            topRight: Radius.circular(16.0),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: Text(
                                'Abu Dhabi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Abu Dhabi';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Dubai',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Dubai';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Sharjah',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Sharjah';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Ajman',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Ajman';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Fujairah',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Fujairah';
                                });
                                Navigator.pop(context);
                              },
                            ),
                            Divider(),
                            ListTile(
                              title: Text(
                                'Umm Al-Quwain',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              onTap: () {
                                setState(() {
                                  selectedEmirate = 'Umm Al-Quwain';
                                });
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
                decoration: const InputDecoration(
                  labelText: 'Region',
                  hintText: 'Select your region',
                  border: OutlineInputBorder(),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                readOnly: true,
                controller: TextEditingController(text: selectedEmirate),
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: PhoneNumberTextField(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: AddressTextField(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: NotesTextField(),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
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
                              child: const Icon(Icons.remove),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            Text(
                              _quantity.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            const SizedBox(width: 6.0),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _quantity++;
                                });
                              },
                              child: const Icon(Icons.add),
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  // Add some vertical spacing between the buttons and the total price
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.transparent,
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          'Total Price: AED ${(_quantity * widget.product!.price).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        colors: [Color(0xFF42A5F5), Color(0xFF1976D2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isPlacingOrder = true;
                        });
                        _placeOrder(
                          name.toString(),
                          selectedEmirate.toString(),
                          phoneNumber.toString(),
                          address.toString(),
                          widget.product!.productTitle.toString(),
                          widget.product!.price.toString(),
                          _quantity.toString(),
                          "Deals4U -> " + notes,
                          context,
                          _isPlacingOrder,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.transparent,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      child: Text(
                        'Place Order',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
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
                  const SizedBox(width: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: '© 2023 ',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                          ),
                        ),
                        TextSpan(
                          text: 'Deals 4U Emirates',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontFamily: 'Pacifico',
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              const url = 'https://www.uaedeals4u.ae';
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                        ),
                        const TextSpan(
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
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
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
                  const SizedBox(width: 10),
                  const Icon(Icons.lock, size: 18, color: Colors.white),
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
        widget.product!.productTitle +
        " Price : " +
        widget.product!.price.toString();
    String url = 'https://wa.me/+971523801390?text=${Uri.encodeFull(message)}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
          title: const Text('Your Order Details'),
          content: const Text('Please fill in required(*) fields.'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
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
        title: const Text('Confirm Order'),
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
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Return false when canceled
            },
            child: const Text('Change Number'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Return true when confirmed
            },
            child: const Text('Confirm'),
          ),
        ],
      );
    },
  );

  if (!confirmed) {
    return;
  }

  String url =
      'https://uaedeals4u.ae/admin/api/public/api/create_order';

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
        child: const Dialog(
          child: Padding(
            padding: EdgeInsets.all(20.0),
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
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 64.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(successMessage),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.pop(context);
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
              title: const Text('Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 64.0,
                  ),
                  const SizedBox(height: 16.0),
                  Text(message),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
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
            title: const Text('Error'),
            content: const Column(
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
                child: const Text('OK'),
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

class AlertDialogFullScreen extends StatefulWidget {
  final CarouselController carouselController;
  final List<String> images;
  final String baseUrl;
  final int initialIndex;

  AlertDialogFullScreen({
    required this.carouselController,
    required this.images,
    required this.baseUrl,
    required this.initialIndex,
  });

  @override
  _AlertDialogFullScreenState createState() => _AlertDialogFullScreenState();
}

class _AlertDialogFullScreenState extends State<AlertDialogFullScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void goToPreviousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    } else {
      Navigator.of(context)
          .pop(); // Dismiss the dialog if no more images on the left
    }
  }

  void goToNextImage() {
    if (_currentIndex < widget.images.length - 1) {
      setState(() {
        _currentIndex++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool showRightArrow = _currentIndex < widget.images.length - 1;

    return Dialog(
      insetPadding: EdgeInsets.zero,
      child: Stack(
        children: [
          InteractiveViewer(
            panEnabled: false,
            minScale: 0.1,
            maxScale: 3.0,
            child: CachedNetworkImage(
              imageUrl: widget.baseUrl + widget.images[_currentIndex],
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                color: Colors.white,
                onPressed: () {
                  goToPreviousImage();
                },
              ),
            ),
          ),
          if (showRightArrow)
            Positioned(
              top: MediaQuery.of(context).padding.top + 16,
              right: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.white,
                  onPressed: () {
                    goToNextImage();
                  },
                ),
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 80,
            child: Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigateToDetailPage extends StatelessWidget {
  final String? detailId;

  NavigateToDetailPage({required this.detailId});

  Future<ProductModelDetail> fetchData() async {
    // Your code to fetch data from the API here
    // For example:
    String apiUrl =
        'https://uaedeals4u.ae/admin/api/public/api/get_product/';

    String url = apiUrl + int.parse(detailId!).toString();
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return ProductModelDetail.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductModelDetail>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the data, show a loading indicator
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          // If data is available, navigate to the ProductDetailScreen
          return ProductDetailScreen(product: snapshot.data!);
        } else {
          // If there's an error, show an error message
          return Center(child: Text('Failed to load data from API'));
        }
      },
    );
  }

// Other code...
}
