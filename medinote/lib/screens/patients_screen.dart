import 'package:flutter/material.dart';
import 'package:medinote/screens/add_screen.dart';
import 'package:medinote/screens/patient_screen.dart';
import 'package:medinote/widgets/patient_card.dart';
import 'package:provider/provider.dart';
import 'package:medinote/providers/patient_provider.dart';

class PatientsScreen extends StatefulWidget {
  final String userId;

  const PatientsScreen({super.key, required this.userId});

  @override
  State<PatientsScreen> createState() => _PatientsScreenState();
}

class _PatientsScreenState extends State<PatientsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().loadPatients(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MediNote',
          style: TextStyle(fontSize: 28.0, fontFamily: 'Pacifico'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddScreen(userId: widget.userId),
            ),
          );
        },
        child: const Icon(Icons.add, size: 28),
      ),
      body: Consumer<PatientProvider>(
        builder: (context, patientProvider, child) {
          if (patientProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Loading patients...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          if (patientProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading patients',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      patientProvider.loadPatients(widget.userId);
                    },
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final patients = patientProvider.patients;
          if (patients.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No patients yet',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap the + button to add a patient',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PatientScreen(
                            patient: patients[index],
                            userId: widget.userId,
                          ),
                        ),
                      );
                    },
                    child: PatientCard(patient: patients[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
