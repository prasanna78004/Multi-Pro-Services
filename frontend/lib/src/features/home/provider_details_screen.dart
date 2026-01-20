import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> providerData;

  const ProviderDetailsScreen({super.key, required this.providerData});

  Future<void> _createBooking(BuildContext context) async {
    try {
      final name = providerData['name'] ?? 'Provider Name';
      final profession = providerData['profession'] ?? 'Professional';
      
      await FirebaseFirestore.instance.collection('bookings').add({
        'serviceType': profession,
        'providerName': name,
        'status': 'pending',
        'userId': 'current_user_id',
        'userName': 'User',
        'address': 'Connaught Place, New Delhi',
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Request Sent Successfully!')),
        );
        context.pop(); 
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = providerData['name'] ?? 'Provider Name';
    final profession = providerData['profession'] ?? 'Professional';
    final distance = providerData['distance'] ?? 'Nearby';
    final rating = providerData['rating'] ?? 5.0;
    final image = providerData['image'] ?? '';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Profile
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[200],
                    child: Text(name[0], style: const TextStyle(fontSize: 40)),
                    // backgroundImage: image.isNotEmpty ? NetworkImage(image) : null, 
                  ),
                  const SizedBox(height: 16),
                  Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text(profession, style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text('$rating (89 reviews)', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem('PRICE', '\$50/hr'),
                _buildStatItem('DISTANCE', distance),
                _buildStatItem('RESPONSE', '~5 min'),
              ],
            ),
            
            const Divider(height: 48, thickness: 8, color: Color(0xFFF5F5F5)),
            
            // Badges
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verified Badges', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildBadge(Icons.verified, 'ID Verified', Colors.green),
                      _buildBadge(Icons.check_circle, 'Background Checked', Colors.blue),
                      _buildBadge(Icons.work, '50+ Jobs Completed', Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
            
           const Divider(height: 48, thickness: 8, color: Color(0xFFF5F5F5)),

            // Recent Work / Reviews
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Recent Reviews', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  _buildReviewItem('Alice M.', 'Quick and professional. Fixed the wiring issue in 20 minutes.'),
                  _buildReviewItem('Bob R.', 'Good service, but arrived a bit late.'),
                ],
              ),
            ),
            
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                   context.push('/chat', extra: {
                     'bookingId': 'direct_${name}_${DateTime.now().millisecondsSinceEpoch}',
                     'otherUserName': name,
                     'otherUserId': 'provider_placeholder',
                   });
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Chat'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => _createBooking(context),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Request Now', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String user, String comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(backgroundColor: Colors.grey[100], radius: 16, child: const Icon(Icons.person, size: 16, color: Colors.grey)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                   children: [
                     Text(user, style: const TextStyle(fontWeight: FontWeight.bold)),
                     const SizedBox(width: 4),
                     const Icon(Icons.star, size: 12, color: Colors.amber),
                   ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: TextStyle(color: Colors.grey[600])),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
