import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'trip_model.dart';

class TripDetailsPage extends StatefulWidget {
  @override
  _TripDetailsPageState createState() => _TripDetailsPageState();
}

class _TripDetailsPageState extends State<TripDetailsPage> {
  final _tripBox = Hive.box<TripModel>('trips');

  final TextEditingController _tripNameController = TextEditingController();
  final TextEditingController _startLocationController = TextEditingController();
  final TextEditingController _endLocationController = TextEditingController();
  final TextEditingController _routeController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  void _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _pickTime(bool isStartTime) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        if (isStartTime) {
          _startTime = pickedTime;
        } else {
          _endTime = pickedTime;
        }
      });
    }
  }

  void _saveTrip() {
    if (_tripNameController.text.isEmpty ||
        _startLocationController.text.isEmpty ||
        _endLocationController.text.isEmpty ||
        _routeController.text.isEmpty ||
        _selectedDate == null ||
        _startTime == null ||
        _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    TripModel trip = TripModel(
      tripName: _tripNameController.text,
      startLocation: _startLocationController.text,
      startTime: _startTime!.format(context),
      endTime: _endTime!.format(context),
      endLocation: _endLocationController.text,
      route: _routeController.text,
      dateOfTrip: DateFormat('yyyy-MM-dd').format(_selectedDate!),
    );

    _tripBox.add(trip);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Trip saved successfully!")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Trip Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _tripNameController,
              decoration: const InputDecoration(labelText: "Trip Name"),
            ),
            TextField(
              controller: _startLocationController,
              decoration: const InputDecoration(labelText: "Start Location"),
            ),
            TextField(
              controller: _endLocationController,
              decoration: const InputDecoration(labelText: "End Location"),
            ),
            TextField(
              controller: _routeController,
              decoration: const InputDecoration(labelText: "Route"),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _pickDate,
                ),
                Text(
                  _selectedDate == null
                      ? "Select Date"
                      : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: () => _pickTime(true),
                ),
                Text(
                  _startTime == null ? "Start Time" : _startTime!.format(context),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.access_time_filled),
                  onPressed: () => _pickTime(false),
                ),
                Text(
                  _endTime == null ? "End Time" : _endTime!.format(context),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTrip,
              child: const Text("Save Trip"),
            ),
          ],
        ),
      ),
    );
  }
}
