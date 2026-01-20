import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../models/service_data.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard> {
  bool _isOnline = false;
  String _workingAs = 'Electrician'; // Default mock service for this provider session

  final List<String> _allServices = ServiceData.categories
      .expand((cat) => cat.services)
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Partner Dashboard'),
        actions: [
          Switch.adaptive(
            value: _isOnline,
            onChanged: (val) => setState(() => _isOnline = val),
            activeColor: Colors.green,
          ),
          const SizedBox(width: 8),
          Center(
            child: Text(
              _isOnline ? "ONLINE" : "OFFLINE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _isOnline ? Colors.green : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isOnline 
                      ? [Colors.green.shade400, Colors.green.shade700]
                      : [Colors.grey.shade400, Colors.grey.shade600],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                   BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    _isOnline ? Icons.wifi : Icons.wifi_off,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isOnline ? "You are Online" : "You are Offline",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _isOnline ? "Waiting for nearby requests..." : "Go online to start earning",
                        style: GoogleFonts.outfit(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Service Selector (Acting as...)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, size: 20, color: Color(0xFF6C63FF)),
                  const SizedBox(width: 12),
                  const Text("Role:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _workingAs,
                        isExpanded: true,
                        style: GoogleFonts.outfit(color: Colors.black, fontSize: 16),
                        items: _allServices.take(15).map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), 
                        onChanged: (val) {
                          if (val != null) setState(() => _workingAs = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Text("Filtered Requests", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            Text("Only showing requests for $_workingAs", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            const SizedBox(height: 16),
            
            // Real-time Requests List (Filtered by Service & Online Status)
            StreamBuilder<QuerySnapshot>(
              stream: _isOnline 
                  ? FirebaseFirestore.instance
                      .collection('bookings')
                      .where('serviceType', isEqualTo: _workingAs)
                      .where('status', whereIn: ['pending', 'accepted'])
                      .snapshots()
                  : const Stream.empty(),
              builder: (context, snapshot) {
                if (!_isOnline) {
                   return Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(Icons.wifi_off, size: 60, color: Colors.grey[200]),
                        const SizedBox(height: 16),
                        const Text("You are currently offline", style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }
                
                if (snapshot.hasError) {
                  // Fallback: If composite index is missing, try simpler query and filter in-memory
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('bookings')
                        .where('status', whereIn: ['pending', 'accepted'])
                        .snapshots(),
                    builder: (context, fallbackSnapshot) {
                      if (fallbackSnapshot.hasError) return const Text('Something went wrong');
                      if (fallbackSnapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                      
                      final filteredDocs = fallbackSnapshot.data?.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return data['serviceType'] == _workingAs;
                      }).toList() ?? [];

                      if (filteredDocs.isEmpty) return _buildNoRequests();
                      return _buildRequestList(filteredDocs);
                    },
                  );
                }
                
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildNoRequests();
                }

                return _buildRequestList(snapshot.data!.docs);
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildNoRequests() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.notifications_none, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text("No requests for $_workingAs", style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRequestList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final doc = docs[index];
        final data = doc.data() as Map<String, dynamic>;
        final status = data['status'] ?? 'pending';
        
        return Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      child: Icon(Icons.person, color: Theme.of(context).primaryColor),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['serviceType'] ?? 'Service Request',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  data['address'] ?? 'Nearby Location',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: status == 'accepted' ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        status.toString().toUpperCase(), 
                        style: TextStyle(
                          color: status == 'accepted' ? Colors.green : Colors.orange, 
                          fontWeight: FontWeight.bold, 
                          fontSize: 12
                        )
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                if (status == 'pending')
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection('bookings').doc(doc.id).update({'status': 'declined'});
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            FirebaseFirestore.instance.collection('bookings').doc(doc.id).update({'status': 'accepted', 'providerId': 'current_provider_id'});
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Accept'),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                             // Go to Chat
                             context.push('/chat', extra: {
                               'bookingId': doc.id,
                               'otherUserName': 'User', 
                               'otherUserId': data['userId'] ?? 'unknown', 
                             });
                          },
                          icon: const Icon(Icons.chat),
                          label: const Text('Chat with User'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6C63FF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
