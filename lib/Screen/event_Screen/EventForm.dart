import 'package:flutter/material.dart';
import 'package:upi_india/upi_india.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../email.dart';
class EventForm extends StatefulWidget {
  final String eventId;
  final String price;

  EventForm({required this.eventId, required this.price});

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _educationController = TextEditingController();

  UpiIndia _upiIndia = UpiIndia();
  List<UpiApp>? apps;
  Future<UpiResponse>? _transaction;

  TextStyle header = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  TextStyle value = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14,
  );

  @override
  void initState() {
    super.initState();
    _upiIndia.getAllUpiApps(mandatoryTransactionId: false).then((value) {
      setState(() {
        apps = value;
      });
    }).catchError((e) {
      apps = [];
    });
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    return _upiIndia.startTransaction(
      app: app,
      receiverUpiId: "6263788922788@paytm",
      receiverName: 'StartUpodero',
      transactionRefId: 'Event_${widget.eventId}',
      transactionNote: 'Payment for event: ${widget.eventId}',
      amount: double.parse(widget.price),
    );
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return Center(
        child: Text(
          "No apps found to handle transaction.",
          style: header,
        ),
      );
    } else {
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () {
                  _transaction = initiateTransaction(app);
                  setState(() {});
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
    }
  }

  String _upiErrorHandler(Object error) {
    if (error is UpiIndiaAppNotInstalledException) {
      return 'Requested app not installed on device';
    } else if (error is UpiIndiaUserCancelledException) {
      return 'You cancelled the transaction';
    } else if (error is UpiIndiaNullResponseException) {
      return 'Requested app didn\'t return any response';
    } else if (error is UpiIndiaInvalidParametersException) {
      return 'Requested app cannot handle the transaction';
    } else {
      return 'An Unknown error has occurred';
    }
  }

  void _checkTxnStatus(String status) {
    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        print('Transaction Successful');
        _submitEventForm();
        break;
      case UpiPaymentStatus.SUBMITTED:
        print('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        print('Transaction Failed');
        break;
      default:
        print('Received an Unknown transaction status');
    }
  }

  void _submitEventForm() {
    // Submit event form code goes here
    print('Event Form Submitted');

    ApiFunc().mail(targetuser:FirebaseAuth.instance.currentUser!.email.toString());
    // Add your form submission logic here
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    return null;
  }

  Widget displayTransactionData(String title, String body) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$title: ", style: header),
          Flexible(
            child: Text(
              body,
              style: value,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Apply for Event'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: _validateName,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: _validateEmail,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: _validatePhone,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _occupationController,
                  decoration: InputDecoration(labelText: 'Occupation'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _genderController,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _educationController,
                  decoration: InputDecoration(labelText: 'Education'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, proceed with UPI payment and submission
                      _transaction = initiateTransaction(apps!.first); // Assuming the first app
                      setState(() {});
                    }
                  },
                  child: Text('Join Event'),
                ),
                SizedBox(height: 20),
                FutureBuilder(
                  future: _transaction,
                  builder: (BuildContext context, AsyncSnapshot<UpiResponse> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            _upiErrorHandler(snapshot.error!),
                            style: header,
                          ),
                        );
                      }

                      UpiResponse _upiResponse = snapshot.data!;

                      String txnId = _upiResponse.transactionId ?? 'N/A';
                      String resCode = _upiResponse.responseCode ?? 'N/A';
                      String txnRef = _upiResponse.transactionRefId ?? 'N/A';
                      String status = _upiResponse.status ?? 'N/A';
                      String approvalRef = _upiResponse.approvalRefNo ?? 'N/A';
                      _checkTxnStatus(status);

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            displayTransactionData('Transaction Id', txnId),
                            displayTransactionData('Response Code', resCode),
                            displayTransactionData('Reference Id', txnRef),
                            displayTransactionData('Status', status.toUpperCase()),
                            displayTransactionData('Approval No', approvalRef),
                          ],
                        ),
                      );
                    } else {
                      return Center(
                        child: Text(''),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
