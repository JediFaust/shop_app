import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shop_provider/src/models/database.dart';
import 'package:shop_provider/src/models/product.dart';

class ProductCreate extends StatefulWidget {
  ProductCreate({Key? key}) : super(key: key);

  static const String routeName = '/create';

  @override
  State<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends State<ProductCreate> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _currencyController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _titleFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _currencyFocus = FocusNode();

  File? file;
  UploadTask? task;

  final List<String> _currency = ['som', '\$', '€', '¥'];
  String? _selectedCurrency = 'som';

  Product newProduct = Product(currency: 'som');

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _currencyController.dispose();

    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _priceFocus.dispose();
    _currencyFocus.dispose();
    super.dispose();
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    setState(() {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new Product'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(10),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                    child: Row(
                      children: const [
                        Icon(Icons.file_open),
                        Text('Select File'),
                      ],
                    ),
                    onPressed: selectFile),
                MaterialButton(
                    child: Row(
                      children: const [
                        Icon(Icons.file_upload),
                        Text('Upload File'),
                      ],
                    ),
                    onPressed: uploadfile),
              ],
            ),
            TextFormField(
              controller: _titleController,
              validator: _titleValidator,
              focusNode: _titleFocus,
              autofocus: true,
              maxLength: 50,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _titleFocus, _descriptionFocus);
              },
              decoration: InputDecoration(
                labelText: 'Title *',
                hintText: 'Enter title of your product',
                prefixIcon: const Icon(Icons.manage_accounts),
                suffixIcon: GestureDetector(
                  onLongPress: () {
                    _titleController.clear();
                  },
                  child: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              onSaved: (value) => newProduct.title = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _descriptionController,
              validator: _descriptionValidator,
              focusNode: _descriptionFocus,
              maxLength: 200,
              onFieldSubmitted: (_) {
                _fieldFocusChange(context, _descriptionFocus, _priceFocus);
              },
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Description *',
                helperText: 'Description of your product',
                prefixIcon: Icon(Icons.phone),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              onSaved: (value) => newProduct.description = value,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _priceController,
              validator: _priceValidator,
              maxLength: 15,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Price',
                icon: Icon(Icons.email),
                suffixIcon: Icon(Icons.delete_outlined),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.amber, width: 2),
                ),
              ),
              onSaved: (value) => newProduct.price = int.parse(value as String),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.map),
                  labelText: 'Currency'),
              items: _currency.map((currency) {
                return DropdownMenuItem(child: Text(currency), value: currency);
              }).toList(),
              onChanged: (currency) {
                setState(() {
                  _selectedCurrency = currency as String;
                  newProduct.currency = currency;
                });
              },
              validator: (value) {
                return null;
              },
              value: _selectedCurrency,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: _formSubmit,
                child: const Text('Add Product',
                    style: TextStyle(color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                )),
          ],
        ),
      ),
    );
  }

  void _formSubmit() async {
    if (newProduct.imageURL != null) {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();

        await Database.addItem(product: newProduct);

        Navigator.pushNamedAndRemoveUntil(
            this.context, '/home', (route) => false);
      } else {
        _showSnackBar(this.context, 'Form is not valid');
      }
    } else {
      _showSnackBar(this.context, 'Image is not uploaded');
    }
  }

  String? _titleValidator(String? value) {
    final _titleExp = RegExp(r'^[A-Za-z ]+$');
    if (value!.isEmpty) {
      return 'Title is required';
    } else if (!_titleExp.hasMatch(value)) {
      return 'Please enter alphabetical characters';
    } else if (_titleController.text.length > 50) {
      return 'Title can\'t be more than 50 symbols';
    } else {
      return null;
    }
  }

  String? _descriptionValidator(String? value) {
    if (value!.isEmpty) {
      return 'Description is required';
    } else if (_descriptionController.text.length > 200) {
      return 'Description can\'t be more than 200 symbols';
    } else {
      return null;
    }
  }

  String? _priceValidator(String? value) {
    final _priceExp = RegExp(r'^[0-9]+$');
    if (!_priceExp.hasMatch(value!)) {
      return 'Price must contain only digits';
    } else if (_priceController.text.length > 15) {
      return 'Price can\'t be more than 15 digits';
    } else {
      return null;
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      content: Text(message),
    ));
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path as String));
  }

  Future uploadfile() async {
    if (file == null) return;

    final fileName = basename(file!.path);
    final destination = 'files/$fileName';

    task = Database.uploadFile(destination, file!);

    if (task == null) return;

    final snapshot = await task!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    setState(() {
      newProduct.imageURL = url;
    });
  }
}
