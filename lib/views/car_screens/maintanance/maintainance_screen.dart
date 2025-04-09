import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'car_maintenance.dart';

class CarMaintenancePage extends StatefulWidget {
  @override
  _CarMaintenancePageState createState() => _CarMaintenancePageState();
}

class _CarMaintenancePageState extends State<CarMaintenancePage> {
  final _carMaintenanceBox = Hive.box<CarMaintenance>('car_maintenance');
  final _formKey = GlobalKey<FormState>();

  DateTime? lastBatteryCheck;
  DateTime? nextBatteryCheck;
  DateTime? lastOilChange;
  DateTime? nextOilChange;
  DateTime? lastTireCheck;
  DateTime? nextTireCheck;
  TextEditingController notesController = TextEditingController();

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDatePicked) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => onDatePicked(picked));
    }
  }

  void _saveMaintenance() {
    if (_formKey.currentState!.validate()) {
      final newMaintenance = CarMaintenance(
        lastBatteryCheck: lastBatteryCheck,
        nextBatteryCheck: nextBatteryCheck,
        lastOilChange: lastOilChange,
        nextOilChange: nextOilChange,
        lastTireCheck: lastTireCheck,
        nextTireCheck: nextTireCheck,
        notes: notesController.text,
      );
      _carMaintenanceBox.put('car_maintenance_info', newMaintenance);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Car maintenance details saved!')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    final savedData = _carMaintenanceBox.get('car_maintenance_info');
    if (savedData != null) {
      lastBatteryCheck = savedData.lastBatteryCheck;
      nextBatteryCheck = savedData.nextBatteryCheck;
      lastOilChange = savedData.lastOilChange;
      nextOilChange = savedData.nextOilChange;
      lastTireCheck = savedData.lastTireCheck;
      nextTireCheck = savedData.nextTireCheck;
      notesController.text = savedData.notes ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Car Maintenance')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                buildDatePicker(
                    'Last Battery Check',
                    lastBatteryCheck,
                    (date) => lastBatteryCheck = date,
                    Icons.battery_charging_full, false),
                buildDatePicker(
                    'Next Battery Check',
                    nextBatteryCheck,
                    (date) => nextBatteryCheck = date,
                    Icons.battery_charging_full, true),
                const Divider(),
                buildDatePicker('Last Oil Change', lastOilChange,
                    (date) => lastOilChange = date, Icons.local_gas_station, false),
                buildDatePicker('Next Oil Change', nextOilChange,
                    (date) => nextOilChange = date, Icons.local_gas_station, true),
                const Divider(),
                buildDatePicker('Last Tire Check', lastTireCheck,
                    (date) => lastTireCheck = date, Icons.tire_repair, false),
                buildDatePicker('Next Tire Check', nextTireCheck,
                    (date) => nextTireCheck = date, Icons.tire_repair, true),
                const SizedBox(height: 20),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(
                      labelText: 'General Notes', border: OutlineInputBorder()),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _saveMaintenance,
                  child: const Text('Save Maintenance Info'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(String label, DateTime? date,
      Function(DateTime) onDatePicked, IconData icon, bool shaded) {
    return ListTile(
      title: Text(label),
      style: ListTileStyle.drawer,
      tileColor: shaded ? Colors.blue.shade300.withOpacity(0.5) : Colors.green.shade300.withOpacity(0.5),
      leading: Icon(icon),
      subtitle: Text(
          date != null ? DateFormat('yyyy-MM-dd').format(date) : 'Select Date',
      style: const TextStyle(fontWeight: FontWeight.bold,),),
      trailing: const Icon(Icons.calendar_today),
      onTap: () => _selectDate(context, onDatePicked),
    );
  }
}
