

const { Firestore } = require('@google-cloud/firestore');

const keyFilePath = process.env.GCP_KEY;
const serviceAccount = JSON.parse(keyFilePath);


// Initialize Firestore
const firestore = new Firestore({
  projectId: process.env.GCP_PROJECT,
  credentials: serviceAccount,
});

async function addDocument() {
  try {
    const docRef = firestore.collection('order').doc('order2');
    const data = {
      name: 'John Doe',
      age: 30,
      email: 'john.doe@example.com',
    };

    await docRef.set(data);
    console.log('Document successfully written!');
  } catch (error) {
    console.error('Error writing document: ', error);
  }
}

addDocument();
