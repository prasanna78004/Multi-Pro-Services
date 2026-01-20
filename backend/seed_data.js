const admin = require("firebase-admin");
const serviceAccount = require("./service-account.json"); // User needs to provide this

// Admin SDK initialization
// For local emulator, we don't need service account if env var is set
if (process.env.FIRESTORE_EMULATOR_HOST) {
    admin.initializeApp({ projectId: "multi-pro-services-demo" });
} else {
    // For production
    try {
        admin.initializeApp({
            credential: admin.credential.cert(serviceAccount)
        });
    } catch (e) {
        console.error("Error initializing. Make sure you have 'service-account.json' or are running emulators.");
        console.error(e);
        process.exit(1);
    }
}

const db = admin.firestore();

const categories = [
    {
        id: 'home',
        name: 'Home Services',
        services: ['Electrician', 'Plumber', 'Carpenter', 'Painter', 'Home Cleaning', 'Pest Control', 'Appliance Repair', 'AC Repair']
    },
    {
        id: 'vehicle',
        name: 'Vehicle Services',
        services: ['Bike Mechanic', 'Car Mechanic', 'Vehicle Washing', 'Tyre Repair', 'Roadside Assistance']
    },
    {
        id: 'health',
        name: 'Health & Wellness',
        services: ['General Doctor', 'Nurse', 'Physiotherapist', 'Fitness Trainer', 'Yoga Instructor']
    },
    {
        id: 'tech',
        name: 'Tech & Digital',
        services: ['Mobile Repair', 'Laptop Repair', 'Wi-Fi Setup', 'Website Development']
    }
];

const mockProviders = [
    {
        name: "John's Plumbing",
        services: ["Plumber"],
        isOnline: true,
        rating: 4.8,
        location: { lat: 28.6139, lng: 77.2090 } // Connaught Place
    },
    {
        name: "Quick Fix Electricians",
        services: ["Electrician"],
        isOnline: true,
        rating: 4.5,
        location: { lat: 28.6200, lng: 77.2100 }
    },
    {
        name: "Home Clean Pro",
        services: ["Home Cleaning", "Pest Control"],
        isOnline: false,
        rating: 4.9,
        location: { lat: 28.6100, lng: 77.2000 }
    }
];

async function seedDatabase() {
    console.log("Starting Database Seed...");

    // Seed Categories/Services
    const batch = db.batch();

    for (const cat of categories) {
        const ref = db.collection('categories').doc(cat.id);
        batch.set(ref, cat);
    }
    console.log(`Prepared ${categories.length} categories.`);

    // Seed Providers
    for (const prov of mockProviders) {
        const ref = db.collection('providers').doc();
        batch.set(ref, prov);
    }
    console.log(`Prepared ${mockProviders.length} providers.`);

    // Seed Mock Bookings
    const mockBookings = [
        {
            serviceType: "Electrician",
            providerName: "FixIt Fast",
            status: "pending",
            userId: "user_1",
            userName: "Alice Smith",
            address: "123 Green Park, New Delhi",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        },
        {
            serviceType: "Plumber",
            providerName: "Rahul Electricals",
            status: "pending",
            userId: "user_2",
            userName: "Bob Jones",
            address: "456 Lajpat Nagar, New Delhi",
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        }
    ];

    for (const booking of mockBookings) {
        const ref = db.collection('bookings').doc();
        batch.set(ref, booking);
    }
    console.log(`Prepared ${mockBookings.length} mock bookings.`);

    await batch.commit();
    console.log("Database Seeded Successfully! 🚀");
}

seedDatabase();
