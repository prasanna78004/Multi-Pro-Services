import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import '../../models/service_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Default to New Delhi coordinates for demo
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 14.4746,
  );

  String? _selectedCategory;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              color: Colors.white,
              child: Row(
                children: [
                  // Logo
                  Icon(Icons.hub, color: Theme.of(context).primaryColor, size: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'MultiProServices',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  // Nav Links
                  _NavLink(title: 'Home', isActive: true),
                  _NavLink(title: 'All Services'),
                  _NavLink(
                    title: 'Provider Mode',
                    onTap: () => context.push('/provider-dashboard'),
                  ),
                  const Spacer(),
                  // Icons
                  IconButton(
                    icon: const Icon(Icons.dark_mode_outlined), 
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Toggling Dark Mode...')));
                    }
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined), 
                    onPressed: () {
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No new notifications')));
                    }
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    child: IconButton(
                      icon: const Icon(Icons.person_outline, color: Colors.black),
                      onPressed: () => context.push('/profile'),
                    ),
                  ),
                ],
              ),
            ),
            
            // 2. Hero Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                image: DecorationImage(
                  image: const NetworkImage('https://i.imgur.com/8Q5F5Mh.png'), // Reliable map pattern image
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.9), BlendMode.lighten),
                ),
              ),
              child: Column(
                children: [
                   Container(
                     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                     decoration: BoxDecoration(
                       color: Colors.purple.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: const Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.circle, size: 8, color: Colors.green),
                         SizedBox(width: 8),
                         Text('Live in New Delhi', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w500)),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   RichText(
                     textAlign: TextAlign.center,
                     text: const TextSpan(
                       style: TextStyle(fontSize: 56, fontWeight: FontWeight.bold, height: 1.1),
                       children: [
                         TextSpan(text: 'Expert Services,\n', style: TextStyle(color: Colors.black87)),
                         TextSpan(text: 'Instantly.', style: TextStyle(color: Color(0xFF6C63FF))),
                       ],
                     ),
                   ),
                   const SizedBox(height: 24),
                   const Text(
                     'Find trusted electricians, plumbers, and more nearby. Powered by AI for perfect matching.',
                     style: TextStyle(fontSize: 18, color: Colors.grey),
                     textAlign: TextAlign.center,
                   ),
                   const SizedBox(height: 40),
                   // Search Bar
                   Container(
                     width: 700,
                     padding: const EdgeInsets.all(8),
                     decoration: BoxDecoration(
                       color: Colors.white,
                       borderRadius: BorderRadius.circular(16),
                       boxShadow: [
                         BoxShadow(
                           color: Colors.black.withOpacity(0.05),
                           blurRadius: 20,
                           offset: const Offset(0, 10),
                         ),
                       ],
                     ),
                     child: Row(
                       children: [
                         const SizedBox(width: 16),
                         const Icon(Icons.search, color: Colors.grey),
                         const SizedBox(width: 16),
                         const Expanded(
                           child: TextField(
                             decoration: InputDecoration(
                               hintText: 'What service do you need?',
                               border: InputBorder.none,
                             ),
                           ),
                         ),
                         FilledButton(
                           onPressed: () {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Searching for services...')));
                           },
                           style: FilledButton.styleFrom(
                             backgroundColor: const Color(0xFF6C63FF),
                             padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                           ),
                           child: const Text('Find', style: TextStyle(fontSize: 16)),
                         ),
                       ],
                     ),
                   ),
                ],
              ),
            ),

            // 3. Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Showing all categories...')));
                        }, 
                        child: const Text('View all', style: TextStyle(color: Color(0xFF6C63FF), fontSize: 16))
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, // 4 columns for web
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 1.4,
                    ),
                    itemCount: ServiceData.categories.length > 8 ? 8 : ServiceData.categories.length,
                    itemBuilder: (context, index) {
                      final category = ServiceData.categories[index];
                      // Use existing card design logic here
                      return _ServiceCard(
                        category: category,
                        index: index,
                        onTap: () {
                          setState(() => _selectedCategory = category.id);
                          _showBookingDialog(context, category);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),

            // 4. Nearby Providers Map Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Column(
                children: [
                  const Text('Nearby Providers', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Explore top rated professionals in your area.', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 500,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        children: [
                          GoogleMap(
                            initialCameraPosition: _kGooglePlex,
                            zoomControlsEnabled: false,
                            markers: {
                              Marker(
                                markerId: const MarkerId('p1'),
                                position: const LatLng(28.6139, 77.2090),
                                infoWindow: InfoWindow(
                                  title: 'FixIt Fast • 4.8 ★', // Name and Rating
                                  snippet: 'Electrician • Tap to view profile',
                                  onTap: () => context.push('/provider-details', extra: {'name': 'FixIt Fast', 'rating': 4.8, 'distance': '0.5 km', 'profession': 'Electrician'}),
                                ),
                              ),
                              Marker(
                                markerId: const MarkerId('p2'),
                                position: const LatLng(28.62, 77.21),
                                infoWindow: InfoWindow(
                                  title: 'Rahul Electricals • 4.5 ★', // Name and Rating
                                  snippet: 'Plumber • Tap to view profile',
                                  onTap: () => context.push('/provider-details', extra: {'name': 'Rahul Electricals', 'rating': 4.5, 'distance': '1.2 km', 'profession': 'Plumber'}),
                                ),
                              ),
                              Marker(
                                markerId: const MarkerId('p3'),
                                position: const LatLng(28.61, 77.20),
                                infoWindow: InfoWindow(
                                  title: 'Delhi Services • 4.2 ★', // Name and Rating
                                  snippet: 'Carpenter • Tap to view profile',
                                  onTap: () => context.push('/provider-details', extra: {'name': 'Delhi Services', 'rating': 4.2, 'distance': '2.0 km', 'profession': 'Carpenter'}),
                                ),
                              ),
                            },
                          ),
                          // "Live" Indicator on Map
                          Positioned(
                             bottom: 20,
                             left: 20,
                             child: Container(
                               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                               child: const Row(children: [Icon(Icons.circle, color: Colors.green, size: 10), SizedBox(width: 8), Text('3 providers online')]),
                             ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer (optional, simple)
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/ai-chat'),
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.auto_awesome, color: Colors.white),
      ),
    );
  }

  void _showBookingDialog(BuildContext context, ServiceCategory category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(category.icon, color: Colors.orange, size: 28),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${category.name} Providers', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('3 providers near Connaught Place', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: 3,
                separatorBuilder: (context, index) => const Divider(height: 32),
                itemBuilder: (context, index) {
                  final names = ['FixIt Fast', 'Rahul Electricals', 'Delhi Services'];
                  final ratings = [4.8, 4.5, 4.2];
                  final distances = ['0.5 km', '1.2 km', '2.0 km'];
                  
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.grey[200],
                        child: Text(names[index][0], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(names[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star, size: 14, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(ratings[index].toString(), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text('${category.name} • ${distances[index]} away', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Calling ${names[index]}...')));
                                    },
                                    icon: const Icon(Icons.call, size: 18),
                                    label: const Text('Call'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.green,
                                      side: const BorderSide(color: Colors.green),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.push('/chat', extra: {
                                        'bookingId': 'demo_chat_${names[index]}',
                                        'otherUserName': names[index],
                                        'otherUserId': 'provider_${index}',
                                      });
                                    },
                                    icon: const Icon(Icons.chat_bubble_outline, size: 18),
                                    label: const Text('Chat'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  context.push('/provider-details', extra: {
                                    'name': names[index],
                                    'rating': ratings[index],
                                    'distance': distances[index],
                                    'profession': category.name,
                                  });
                                },
                                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF6C63FF)),
                                child: const Text('View Profile'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback? onTap;

  const _NavLink({required this.title, this.isActive = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {
        // Show feedback for demo
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigating to $title...')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? const Color(0xFF6C63FF) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final ServiceCategory category;
  final int index;
  final VoidCallback onTap;

  const _ServiceCard({required this.category, required this.index, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  bool _isHovered = false;

  // Vibrant color palette for services
  final List<Color> _colors = const [
    Color(0xFF6C63FF), // Purple
    Color(0xFFFF6584), // Pink
    Color(0xFF38B6FF), // Blue
    Color(0xFFFFBA08), // Yellow/Orange
    Color(0xFF00C9A7), // Teal
    Color(0xFF845EC2), // Deep Purple
    Color(0xFFFF9671), // Salmon
    Color(0xFF2C73D2), // Strong Blue
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[widget.index % _colors.length];

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? color : Colors.grey.shade200, 
              width: _isHovered ? 2 : 1
            ),
            boxShadow: [
              if (_isHovered)
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 2,
                )
              else
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.category.icon, color: color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(
                widget.category.name, 
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
              ),
              const SizedBox(height: 8),
              Text(
                widget.category.services.take(2).join(', '),
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
