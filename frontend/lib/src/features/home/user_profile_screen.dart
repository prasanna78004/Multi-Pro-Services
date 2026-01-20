import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('My Profile', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=12'), // Placeholder
              ),
            ),
            const SizedBox(height: 16),
            Text('Rahul Sharma', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold)),
            Text('+91 98765 43210', style: GoogleFonts.outfit(color: Colors.grey, fontSize: 16)),
            
            const SizedBox(height: 32),

            // Wallet Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF4834D4)]),
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet Balance', style: GoogleFonts.outfit(color: Colors.white70)),
                      const SizedBox(height: 8),
                      Text('₹ 1,250.00', style: GoogleFonts.outfit(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 32),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Align(alignment: Alignment.centerLeft, child: Text('Menu', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold))),
            const SizedBox(height: 16),

            // Menu Options
            _buildMenuOption(context, icon: Icons.history, title: 'Booking History', onTap: () {}),
            _buildMenuOption(context, icon: Icons.payment, title: 'Payment Methods', onTap: () {}),
            _buildMenuOption(context, icon: Icons.help_outline, title: 'Help & Support', onTap: () {}),
            _buildMenuOption(context, icon: Icons.logout, title: 'Logout', isDestructive: true, onTap: () => context.go('/login')),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap, bool isDestructive = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : Theme.of(context).primaryColor),
        ),
        title: Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.w500, color: isDestructive ? Colors.red : Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
