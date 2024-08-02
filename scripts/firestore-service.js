const { Firestore } = require('@google-cloud/firestore');

const serviceAccount = JSON.parse($env.GCP_KEY);

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
firestore.collection('orders').doc('order1').set(data)
  .then(() => {
    console.log('Document successfully written to Firestore.');
  })
  .catch(error => {
    console.error('Error writing document: ', error);
  });
