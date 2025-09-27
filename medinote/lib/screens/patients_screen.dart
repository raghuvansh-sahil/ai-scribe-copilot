import 'package:flutter/material.dart';
import 'package:medinote/models/patient.dart';
import 'package:medinote/screens/patient_screen.dart';
import 'package:medinote/widgets/patient_card.dart';

class PatientsScreen extends StatelessWidget {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FutureBuilder<List<Patient>>(
        future: NetworkHandler.getReceipts(),
        builder: (context, AsyncSnapshot<List<Patient>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData && snapshot.data != null) {
            final patients = snapshot.data!;
            if (patients.isEmpty) {
              return const Center(child: Text('No patients added.'));
            }
            return ListView.builder(
              itemCount: patients.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PatientScreen(patient: patients[index]),
                      ),
                    );
                  },
                  child: PatientCard(patient: patients[index]),
                );
              },
            );
          } else {
            return const Center(child: Text('Nothing to show.'));
          }
        },
      ),
    );
  }
}
