import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'emergency_contact.dart';

class EmergencyCallPage extends StatefulWidget {
  const EmergencyCallPage({super.key});

  @override
  _EmergencyCallPageState createState() => _EmergencyCallPageState();
}

class _EmergencyCallPageState extends State<EmergencyCallPage> {
  final _emergencyBox = Hive.box<EmergencyContact>('emergency_contacts');

  void _addEmergencyContact() {
    showModal(
      context: context,
      builder: (context) => EmergencyContactForm(onSave: (contact) {
        _emergencyBox.add(contact);
        setState(() {});
      }),
    );
  }

  void _callNumber(String number) async {
    final Uri url = Uri.parse("tel:$number");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _deleteContact(int index) {
    setState(() {
      _emergencyBox.deleteAt(index); // Delete from Hive
    });
  }
  void _confirmDelete(int index, String contactName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Contact"),
        content: Text("Are you sure you want to delete $contactName?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel button
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              _deleteContact(index);
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Column(
        children: [
          const SizedBox(height: 30,),
          Transform.scale( scale: 8, child: Lottie.asset('assets/emergency.json', height: 150, width: 150,)),
          const SizedBox(height: 30,),
          Expanded(
            child: _emergencyBox.isEmpty
                ? const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No emergency contacts added.'),
                      ],
                    ),
                  ],
                )
                : ListView.builder(
              itemCount: _emergencyBox.length,
              itemBuilder: (context, index) {
                final contact = _emergencyBox.getAt(index) as EmergencyContact;

                return OpenContainer(
                  openBuilder: (context, closeContainer) => EmergencyContactForm(
                    contact: contact,
                    onSave: (updatedContact) {
                      _emergencyBox.putAt(index, updatedContact);
                      setState(() {});
                    },
                  ),
                  closedColor: Colors.transparent,
                  closedBuilder: (context, openContainer) => ListTile(
                    leading: Icon(IconData(contact.iconCode, fontFamily: 'MaterialIcons'), color: Colors.red),
                    title: Text(contact.name),
                    subtitle: Text(contact.phone),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.call, color: Colors.green),
                          onPressed: () => _callNumber(contact.phone),
                        ),
                        // Delete button
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _confirmDelete(index, contact.name);
                          },
                        ),
                      ],
                    ),
                  )
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEmergencyContact,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class EmergencyContactForm extends StatefulWidget {
  final EmergencyContact? contact;
  final Function(EmergencyContact) onSave;

  EmergencyContactForm({this.contact, required this.onSave});

  @override
  _EmergencyContactFormState createState() => _EmergencyContactFormState();
}

class _EmergencyContactFormState extends State<EmergencyContactForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  IconData selectedIcon = Icons.local_hospital;

  @override
  void initState() {
    super.initState();
    if (widget.contact != null) {
      nameController.text = widget.contact!.name;
      phoneController.text = widget.contact!.phone;
      selectedIcon = widget.contact!.icon;
    }
  }

  void _saveContact() {
    if (_formKey.currentState!.validate()) {
      final newContact = EmergencyContact(
        name: nameController.text,
        phone: phoneController.text,
        iconCode: selectedIcon.codePoint, // Save icon as codePoint
      );
      widget.onSave(newContact);
      Navigator.pop(context);
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact == null ? 'Add a new contact' : 'Edit contact details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Text(widget.contact == null ? 'Add a new contact' : 'Edit contact details'),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Contact Name'),
                      validator: (value) => value!.isEmpty ? 'Enter a name' : null,
                    ),
                    TextFormField(
                      controller: phoneController,
                      decoration: const InputDecoration(labelText: 'Phone Number'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value!.isEmpty ? 'Enter a phone number' : null,
                    ),
                    const SizedBox(height: 20),
                    // Wrap(
                    //   spacing: 10,
                    //   children: [
                    //     IconButton(icon: Icon(Icons.local_hospital, color: selectedIcon == Icons.local_hospital ? Colors.red : Colors.grey), onPressed: () => setState(() => selectedIcon = Icons.local_hospital)),
                    //     IconButton(icon: Icon(Icons.local_police, color: selectedIcon == Icons.local_police ? Colors.red : Colors.grey), onPressed: () => setState(() => selectedIcon = Icons.local_police)),
                    //     IconButton(icon: Icon(Icons.fire_truck, color: selectedIcon == Icons.fire_truck ? Colors.red : Colors.grey), onPressed: () => setState(() => selectedIcon = Icons.fire_truck)),
                    //   ],
                    // ),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: double.infinity, child: ElevatedButton(onPressed: _saveContact, child: const Text('Save'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}