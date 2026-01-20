import 'package:flutter/material.dart';

class ServiceCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<String> services;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.services,
  });
}

class ServiceData {
  static const List<ServiceCategory> categories = [
    ServiceCategory(
      id: 'home',
      name: 'Home Services',
      icon: Icons.home,
      services: [
        'Electrician', 'Plumber', 'Carpenter', 'Painter', 'Home Cleaning',
        'Pest Control', 'Appliance Repair', 'RO / Water Purifier Service',
        'AC Repair & Installation', 'CCTV Installation'
      ],
    ),
    ServiceCategory(
      id: 'vehicle',
      name: 'Vehicle Services',
      icon: Icons.directions_car,
      services: [
        'Bike Mechanic', 'Car Mechanic', 'Vehicle Washing', 'Tyre Repair',
        'Battery Replacement', 'Roadside Assistance'
      ],
    ),
    ServiceCategory(
      id: 'tech',
      name: 'Tech & Digital',
      icon: Icons.computer,
      services: [
        'Mobile Repair', 'Laptop / Computer Repair', 'Wi-Fi & Network Setup',
        'Software Installation', 'Website Development', 'App Development',
        'UI/UX Design', 'Digital Marketing', 'SEO Services'
      ],
    ),
    ServiceCategory(
      id: 'education',
      name: 'Education',
      icon: Icons.school,
      services: [
        'Home Tutor', 'Online Tutor', 'Spoken English Trainer', 'Coding Instructor',
        'Exam Coaching', 'Music Teacher', 'Dance Instructor'
      ],
    ),
    ServiceCategory(
      id: 'health',
      name: 'Health & Wellness',
      icon: Icons.health_and_safety,
      services: [
        'General Doctor', 'Nurse / Caretaker', 'Physiotherapist', 'Fitness Trainer',
        'Yoga Instructor', 'Dietician', 'Mental Wellness Coach'
      ],
    ),
    ServiceCategory(
      id: 'beauty',
      name: 'Beauty & Personal Care',
      icon: Icons.face,
      services: [
        'Salon at Home', 'Makeup Artist', 'Hair Stylist', 'Massage Therapist',
        'Bridal Makeup'
      ],
    ),
     ServiceCategory(
      id: 'professional',
      name: 'Professional Services',
      icon: Icons.work,
      services: [
        'Accountant', 'Tax Consultant', 'Legal Advisor', 'Business Consultant',
        'Company Registration', 'Documentation Services'
      ],
    ),
    ServiceCategory(
      id: 'daily',
      name: 'Daily & Local',
      icon: Icons.shopping_cart,
      services: [
        'Delivery Partner', 'Grocery Delivery', 'Courier Service', 'Errand Runner',
        'House Shifting', 'Packers & Movers'
      ],
    ),
    ServiceCategory(
      id: 'construction',
      name: 'Construction',
      icon: Icons.construction,
      services: [
        'Civil Engineer', 'Construction Worker', 'Interior Designer', 'Architect',
        'Welding Services'
      ],
    ),
    ServiceCategory(
      id: 'emergency',
      name: 'Emergency',
      icon: Icons.emergency,
      services: [
        'Emergency Electrician', 'Emergency Plumber', 'Medical Assistance', 'Locksmith'
      ],
    ),
  ];
}
