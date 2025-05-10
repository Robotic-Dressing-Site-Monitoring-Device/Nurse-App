const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const { initializeApp } = require("firebase-admin/app");
const { getFirestore } = require("firebase-admin/firestore");
const axios = require("axios");

initializeApp();

exports.analyzeImageWithRoboflow = onDocumentCreated("patients/{patientId}/photos/{photoId}", async (event) => {
  const snap = event.data;
  const data = snap.data();

  const imageUrl = data.imageURL;
  if (data.analyzed === true || !imageUrl) {
    console.log("No image or already analyzed");
    return null;
  }

  try {
    const response = await axios.get(imageUrl, { responseType: "arraybuffer" });
    const base64Image = Buffer.from(response.data).toString("base64");

    const roboflowResponse = await axios.post(
      "https://serverless.roboflow.com/my-first-project-x5u0k/8?api_key=Gl3Piz2o3nvjnAVyTJvT",
      base64Image,
      {
        headers: { "Content-Type": "application/x-www-form-urlencoded" },
      }
    );

    const predictions = roboflowResponse.data.predictions;
    let issues = [];

    for (const pred of predictions) {
      if (pred.confidence >= 0.4) {
        const cls = pred.class.toLowerCase();
        if (["pus", "blood", "dressing damage", "redness"].includes(cls)) {
          issues.push(cls.replace(" ", "_")); // e.g. dressing_damage
        }
      }
    }

    if (issues.length === 0) {
      issues.push("none");
    }

    const status = issues.includes("none") ? "good" : "urgent";

    const db = getFirestore();
    await db
      .collection("patients")
      .doc(event.params.patientId)
      .collection("photos")
      .doc(event.params.photoId)
      .set({
        issue: issues,         
        status: status,
        analyzed: true
      }, { merge: true });     

    console.log(`✅ Done: issue = ${issues}, status = ${status}`);
    return null;

  } catch (err) {
    console.error("❌ Roboflow fail:", err);
    return null;
  }
});
