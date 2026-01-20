import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/service_data.dart';

class ProviderRegistrationScreen extends StatefulWidget {
  const ProviderRegistrationScreen({super.key});

  @override
  State<ProviderRegistrationScreen> createState() => _ProviderRegistrationScreenState();
}

class _ProviderRegistrationScreenState extends State<ProviderRegistrationScreen> {
  final _nameController = TextEditingController();
  final Set<String> _selectedServices = {};
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Partner Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Join MultiPro Services',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            const Text('Fill in your details and select services you offer.'),
            const SizedBox(height: 32),
            
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name / Business Name',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'Select Services',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            ...ServiceData.categories.map((category) {
              return ExpansionTile(
                leading: Icon(category.icon),
                title: Text(category.name),
                children: category.services.map((service) {
                  final isSelected = _selectedServices.contains(service);
                  return CheckboxListTile(
                    value: isSelected,
                    title: Text(service),
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedServices.add(service);
                        } else {
                          _selectedServices.remove(service);
                        }
                      });
                    },
                  );
                }).toList(),
              );
            }),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submitRegistration,
                child: _isSubmitting 
                    ? const CircularProgressIndicator() 
                    : const Text('Complete Registration'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    if (_nameController.text.isEmpty || _selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill name and select at least one service.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      // Mock User ID
      const userId = 'demo_provider_123';
      
      await FirebaseFirestore.instance.collection('providers').doc(userId).set({
        'name': _nameController.text,
        'services': _selectedServices.toList(),
        'isOnline': false,
        'rating': 5.0, // Start with 5 stars
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        context.go('/provider-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
