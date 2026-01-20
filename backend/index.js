const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { VertexAI } = require('@google-cloud/vertexai');

admin.initializeApp();
const db = admin.firestore();

// Initialize Vertex AI
// Note: Requires project_id and location to be set in environment config or hardcoded for demo
const project = process.env.GCLOUD_PROJECT || 'multi-pro-services-demo';
const location = 'us-central1';
const vertex_ai = new VertexAI({ project: project, location: location });

exports.helloWorld = functions.https.onRequest((request, response) => {
  response.send("MultiProServices Backend is Live!");
});

// Match Providers: Listens for new bookings and assigns the nearest online provider
exports.matchProviders = functions.firestore
  .document('bookings/{bookingId}')
  .onCreate(async (snap, context) => {
    const booking = snap.data();
    const bookingId = context.params.bookingId;

    if (booking.status !== 'pending') return null;

    console.log(`Searching providers for booking ${bookingId} at ${booking.address}`);

    // 1. Query online providers offering this service
    // Note: In a real app, use GeoFirestore for radius search
    const providersSnapshot = await db.collection('providers')
      .where('isOnline', '==', true)
      .where('services', 'array-contains', booking.serviceType)
      .limit(5)
      .get();

    if (providersSnapshot.empty) {
      console.log('No online providers found.');
      return snap.ref.update({ status: 'no_providers', notes: 'No providers available nearby.' });
    }

    // 2. Simple ranking logic (mock distance calculation)
    // In production, calculating distance between booking.coordinates and provider.location
    const matchedProvider = providersSnapshot.docs[0];

    console.log(`Matched with provider: ${matchedProvider.id}`);

    // 3. Assign to provider
    return snap.ref.update({
      status: 'assigned',
      providerId: matchedProvider.id,
      providerName: matchedProvider.data().name || 'Service Partner',
      matchedAt: admin.firestore.FieldValue.serverTimestamp()
    });
  });

// AI Service Recommendation: Uses Vertex AI to suggest services based on user query
exports.recommendServices = functions.https.onCall(async (data, context) => {
  const userQuery = data.query;
  if (!userQuery) return { suggestions: [] };

  try {
    // Vertex AI Text Generation Configuration
    // Ensure you have enabled the Vertex AI API in Google Cloud Console
    const generativeModel = vertex_ai.preview.getGenerativeModel({
      model: 'gemini-pro',
      generation_config: { max_output_tokens: 256 }
    });

    const prompt = `
          Context: A home service app offering plumbing, cleaning, electrical, etc.
          User Request: "${userQuery}"
          Task: Suggest 3 specific services from the app catalog that match this request. Return as JSON array of strings.
        `;

    const result = await generativeModel.generateContent({
      contents: [{ role: 'user', parts: [{ text: prompt }] }]
    });

    const responseText = result.response.candidates[0].content.parts[0].text;
    // Basic parsing assuming AI returns valid JSON or list
    // For robustness, consider structured output or regex parsing
    return { suggestion_raw: responseText };

  } catch (error) {
    console.error("Vertex AI Error:", error);
    // Fallback or Mock response for demo if API not enabled
    return {
      suggestions: ['General Cleaning', 'Plumbing Check', 'Appliance Repair'],
      note: "AI service unavailable, showing defaults."
    };
  }
});
