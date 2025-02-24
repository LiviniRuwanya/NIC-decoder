import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'result_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _nicController = TextEditingController();
  String _nicType = 'Old NIC';
  static const List<String> _nicTypes = ['Old NIC', 'New NIC'];

  bool _validateNic(String nic) {
    if (_nicType == 'Old NIC') {
      return nic.length == 10 && RegExp(r'^\d{9}[vVxX]$').hasMatch(nic);
    }
    return nic.length == 12 && RegExp(r'^\d{12}$').hasMatch(nic);
  }

  @override
  void dispose() {
    _nicController.dispose();
    super.dispose();
  }

  void _handleDecode() {
    final String nic = _nicController.text.trim();
    if (nic.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a valid NIC number',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (!_validateNic(nic)) {
      Get.snackbar(
        'Error',
        'Invalid NIC format for $_nicType',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.to(() => ResultScreen(nic: nic, nicType: _nicType));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade900,
              Colors.blue.shade500,
              Colors.blue.shade300,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                title: Text('NIC Decoder',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                centerTitle: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              Expanded(
                child: Center(
                  child: Card(
                    margin: EdgeInsets.all(16),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Enter NIC Details',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 25),
                          DropdownButtonFormField<String>(
                            value: _nicType,
                            decoration: InputDecoration(
                              labelText: 'Select NIC Type',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                            ),
                            items: _nicTypes.map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _nicType = newValue!;
                              });
                            },
                          ),
                          SizedBox(height: 20),
                          TextField(
                            controller: _nicController,
                            decoration: InputDecoration(
                              labelText: 'Enter NIC Number',
                              hintText: _nicType == 'Old NIC'
                                  ? 'e.g., 853400937v'
                                  : 'e.g., 198534000937',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              filled: true,
                              fillColor: Colors.blue.shade50,
                            ),
                          ),
                          SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: _handleDecode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade900,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 5,
                            ),
                            child: Text(
                              'Decode NIC',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}