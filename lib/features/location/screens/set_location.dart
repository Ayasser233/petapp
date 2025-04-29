import 'package:flutter/material.dart';

class SetLocationScreen extends StatelessWidget {
  const SetLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Choose Location'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(child: Text('Map Placeholder')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'Popular Locations',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Houses'),
                  subtitle: Text('Beverly Hills, California'),
                  trailing: Text('1.2 KM'),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Warehouses'),
                  subtitle: Text('UPS Worldport, Louisville, Kentucky'),
                  trailing: Text('3.1 KM'),
                ),
                const ListTile(
                  leading: Icon(Icons.location_on),
                  title: Text('Hotels'),
                  subtitle: Text('Hotel del Coronado, San Diego'),
                  trailing: Text('4.3 KM'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}