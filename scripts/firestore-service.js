const { Firestore } = require('@google-cloud/firestore');


// Load the service account key JSON file
const keyFilePath = process.env.GCP_KEY;
const serviceAccount = JSON.parse(keyFilePath);

// Initialize Firestore client
const firestore = new Firestore({
  projectId: $env.GCP_PROJECT,
  credentials: serviceAccount,
});

// Data to be saved
const data = {
  name: 'John Doe',
  email: 'john.doe@example.com',
};

// Add a new document
firestore.collection('order').doc('order1').set(data)
  .then(() => {
    console.log('Document successfully written to Firestore.');
  })
  .catch(error => {
    console.error('Error writing document: ', error);
  });
