import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ApplicationFormScreen extends StatefulWidget {
  final Map<String, dynamic> property;

  const ApplicationFormScreen({Key? key, required this.property}) : super(key: key);

  @override
  _ApplicationFormScreenState createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  final _formData = <String, dynamic>{};
  final _fileData = <String, PlatformFile?>{};
  int _currentPage = 0;
  bool _isLoading = false;
  bool _submitted = false;
  String _submissionMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSavedFormData();
  }

  Future<void> _loadSavedFormData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        // Load form data from shared preferences
        _formData['employerName'] = prefs.getString('employerName') ?? '';
        _formData['workStation'] = prefs.getString('workStation') ?? '';
        _formData['employerLocation'] = prefs.getString('employerLocation') ?? '';
        _formData['employerAddress'] = prefs.getString('employerAddress') ?? '';
        _formData['occupation'] = prefs.getString('occupation') ?? '';
        _formData['telephone'] = prefs.getString('telephone') ?? '';

        _formData['spouseSurname'] = prefs.getString('spouseSurname') ?? '';
        _formData['spouseForename'] = prefs.getString('spouseForename') ?? '';
        _formData['title'] = prefs.getString('title') ?? '';
        _formData['otherNames'] = prefs.getString('otherNames') ?? '';
        _formData['maidenName'] = prefs.getString('maidenName') ?? '';
        _formData['nationality'] = prefs.getString('nationality') ?? '';
        _formData['idNumber'] = prefs.getString('idNumber') ?? '';
        _formData['dob'] = prefs.getString('dob') ?? null;
        _formData['placeOfBirth'] = prefs.getString('placeOfBirth') ?? '';
        _formData['telephone2'] = prefs.getString('telephone2') ?? '';
        _formData['cellphone'] = prefs.getString('cellphone') ?? '';
        _formData['email'] = prefs.getString('email') ?? '';
        _formData['spouseEmployerName'] = prefs.getString('spouseEmployerName') ?? '';
        _formData['spouseWorkStation'] = prefs.getString('spouseWorkStation') ?? '';
        _formData['spouseEmployerLocation'] = prefs.getString('spouseEmployerLocation') ?? '';
        _formData['spouseEmployerAddress'] = prefs.getString('spouseEmployerAddress') ?? '';
        _formData['spouseOccupation'] = prefs.getString('spouseOccupation') ?? '';
        _formData['spouseTelephone'] = prefs.getString('spouseTelephone') ?? '';

        _formData['homeVillage'] = prefs.getString('homeVillage') ?? '';
        _formData['district'] = prefs.getString('district') ?? '';
        _formData['ward'] = prefs.getString('ward') ?? '';
        _formData['headmanName'] = prefs.getString('headmanName') ?? '';
        _formData['headmanAddress'] = prefs.getString('headmanAddress') ?? '';
        _formData['headmanTelephone'] = prefs.getString('headmanTelephone') ?? '';

        _formData['dependantName'] = prefs.getString('dependantName') ?? '';
        _formData['dependantDob'] = prefs.getString('dependantDob') ?? null;
        _formData['dependantRelationship'] = prefs.getString('dependantRelationship') ?? '';

        _fileData['idDocument'] = null;
        _fileData['proofOfIncome'] = null;
        _fileData['supportingDocuments'] = null;
      });
    } catch (e) {
      print('Error loading form data: $e');
    }
  }

  Future<void> _saveFormDataLocally() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('employerName', _formData['employerName']);
      prefs.setString('workStation', _formData['workStation']);
      prefs.setString('employerLocation', _formData['employerLocation']);
      prefs.setString('employerAddress', _formData['employerAddress']);
      prefs.setString('occupation', _formData['occupation']);
      prefs.setString('telephone', _formData['telephone']);

      prefs.setString('spouseSurname', _formData['spouseSurname']);
      prefs.setString('spouseForename', _formData['spouseForename']);
      prefs.setString('title', _formData['title']);
      prefs.setString('otherNames', _formData['otherNames']);
      prefs.setString('maidenName', _formData['maidenName']);
      prefs.setString('nationality', _formData['nationality']);
      prefs.setString('idNumber', _formData['idNumber']);
      prefs.setString('dob', _formData['dob']!.toString());
      prefs.setString('placeOfBirth', _formData['placeOfBirth']);
      prefs.setString('telephone2', _formData['telephone2']);
      prefs.setString('cellphone', _formData['cellphone']);
      prefs.setString('email', _formData['email']);
      prefs.setString('spouseEmployerName', _formData['spouseEmployerName']);
      prefs.setString('spouseWorkStation', _formData['spouseWorkStation']);
      prefs.setString('spouseEmployerLocation', _formData['spouseEmployerLocation']);
      prefs.setString('spouseEmployerAddress', _formData['spouseEmployerAddress']);
      prefs.setString('spouseOccupation', _formData['spouseOccupation']);
      prefs.setString('spouseTelephone', _formData['spouseTelephone']);

      prefs.setString('homeVillage', _formData['homeVillage']);
      prefs.setString('district', _formData['district']);
      prefs.setString('ward', _formData['ward']);
      prefs.setString('headmanName', _formData['headmanName']);
      prefs.setString('headmanAddress', _formData['headmanAddress']);
      prefs.setString('headmanTelephone', _formData['headmanTelephone']);

      prefs.setString('dependantName', _formData['dependantName']);
      prefs.setString('dependantDob', _formData['dependantDob']!.toString());
      prefs.setString('dependantRelationship', _formData['dependantRelationship']);
    } catch (e) {
      print('Error saving form data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Ensure to call super.build(context) to keep state alive

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lease Application Form'),
        backgroundColor: Colors.orange,
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            onChanged: () {
              _saveFormDataLocally();
            },
            child: Column(
              children: [
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildEmploymentDetailsPage(),
                      _buildSpouseParticularsPage(),
                      _buildHomeVillageDetailsPage(),
                      _buildDependantsPage(),
                      _buildAttachmentsPage(),
                    ],
                  ),
                ),
                _buildNavigationButtons(),
                if (_submitted) _buildSubmissionMessage(),
              ],
            ),
          ),
          if (_isLoading)
            Center(
              child: SpinKitCircle(
                color: Colors.orange,
                size: 50.0,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSubmissionMessage() {
    return AlertDialog(
      title: const Text('Application Submission'),
      content: Text(_submissionMessage),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_currentPage > 0)
            ElevatedButton(
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Previous'),
            ),
          if (_currentPage < 4)
            ElevatedButton(
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: const Text('Next'),
            ),
          if (_currentPage == 4)
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Submit'),
            ),
        ],
      ),
    );
  }

  Widget _buildEmploymentDetailsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildTextField('Employer\'s Name', 'employerName'),
          _buildTextField('Work Station/Branch', 'workStation'),
          _buildTextField('Location', 'employerLocation'),
          _buildTextField('Employer\'s Address', 'employerAddress'),
          _buildTextField('Occupation', 'occupation'),
          _buildTextField('Telephone', 'telephone'),
        ],
      ),
    );
  }

  Widget _buildSpouseParticularsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildTextField('Spouse\'s Surname', 'spouseSurname'),
          _buildTextField('Spouse\'s Forename', 'spouseForename'),
          _buildTextField('Title', 'title'),
          _buildTextField('Other Names', 'otherNames'),
          _buildTextField('Maiden Name', 'maidenName'),
          _buildTextField('Nationality', 'nationality'),
          _buildTextField('Omang/ID or Passport Number', 'idNumber'),
          _buildDateField('Date of Birth', 'dob'),
          _buildTextField('Place of Birth', 'placeOfBirth'),
          _buildTextField('Telephone', 'telephone2'),
          _buildTextField('Cellphone', 'cellphone'),
          _buildTextField('E-mail Address', 'email'),
          _buildTextField('Spouse\'s Employer\'s Name', 'spouseEmployerName'),
          _buildTextField('Spouse\'s Work Station/Branch', 'spouseWorkStation'),
          _buildTextField('Spouse\'s Location', 'spouseEmployerLocation'),
          _buildTextField('Spouse\'s Employer\'s Address', 'spouseEmployerAddress'),
          _buildTextField('Spouse\'s Occupation', 'spouseOccupation'),
          _buildTextField('Spouse\'s Telephone', 'spouseTelephone'),
        ],
      ),
    );
  }

  Widget _buildHomeVillageDetailsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildTextField('Home Village', 'homeVillage'),
          _buildTextField('District', 'district'),
          _buildTextField('Ward', 'ward'),
          _buildTextField('Headman\'s Name', 'headmanName'),
          _buildTextField('Headman\'s Address', 'headmanAddress'),
          _buildTextField('Headman\'s Telephone', 'headmanTelephone'),
        ],
      ),
    );
  }

  Widget _buildDependantsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildTextField('Dependant\'s Name', 'dependantName'),
          _buildDateField('Dependant\'s Date of Birth', 'dependantDob'),
          _buildTextField('Dependant\'s Relationship', 'dependantRelationship'),
        ],
      ),
    );
  }

  Widget _buildAttachmentsPage() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          _buildFileUploadField('ID Document', 'idDocument'),
          _buildFileUploadField('Proof of Income', 'proofOfIncome'),
          _buildFileUploadField('Other Supporting Documents', 'supportingDocuments'),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          // Validate if the field is required
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
        onSaved: (value) {
          // Always update _formData with the entered value or 'none' if empty
          _formData[field] = value ?? 'none';
        },
        onChanged: (value) {
          // Update form data on change
          _formData[field] = value;
        },
        initialValue: _formData.containsKey(field) ? _formData[field] : '',
      ),
    );
  }

  Widget _buildDateField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (pickedDate != null) {
            setState(() {
              _formData[field] = pickedDate;
            });
          }
        },
        child: AbsorbPointer(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
            ),
            validator: (value) {
              // Validate if the date field is required
              if (_formData[field] == null) {
                return 'Please select $label';
              }
              return null;
            },
            onSaved: (value) {
              // Value is not used since the date is picked using the date picker
            },
            controller: TextEditingController(
              text: _formData[field] != null
                  ? (_formData[field] as DateTime).toLocal().toString().split(' ')[0]
                  : '',
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          ElevatedButton(
            onPressed: () => _selectFile(field),
            child: const Text('Upload File'),
          ),
          if (_fileData[field] != null)
            Text('Selected File: ${_fileData[field]!.name}'),
        ],
      ),
    );
  }

  Future<void> _selectFile(String field) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          _fileData[field] = result.files.first;
        });
        print("File selected: ${result.files.first.name}");
      } else {
        print("File selection canceled.");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  Future<void> _uploadFilesAndSubmitForm() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Upload files to Firebase Storage and get their URLs
      for (String key in _fileData.keys) {
        if (_fileData[key] != null) {
          final fileName = _fileData[key]!.name;
          final filePath = 'user_files/${FirebaseAuth.instance.currentUser!.uid}/$fileName';
          final fileRef = FirebaseStorage.instance.ref().child(filePath);
          await fileRef.putData(_fileData[key]!.bytes!);
          final fileUrl = await fileRef.getDownloadURL();
          _formData[key] = fileUrl;
        }
      }

      // Save the form data to Firestore
      DocumentReference docRef = await FirebaseFirestore.instance.collection('applications').add(_formData);

      setState(() {
        _submitted = true;
        _submissionMessage = 'Your application has been successfully submitted.';
      });
      print('Document ID: ${docRef.id}');
    } catch (error) {
      setState(() {
        _submitted = true;
        _submissionMessage = 'Error submitting application: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _uploadFilesAndSubmitForm();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
