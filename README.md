# Nurse-App
This repository holds the iOS application that serves as a companion tool to receive and notify on duty nurses with updates on ICU patients' central line dressing status.
**************************************************************************8

Nurese APP

The app is build with SwiftUI, Firebase, and Roboflow AI. 

The app design for the nurse to manage patient information, capture wound photos, track dressing statuses, and record nursing notes.
 
Patient List: Display all the patient load from Firebase, and the status will refresh every 10 seconds.

Patient Status: This shows the patient's current status, and the recent status button let user check all previous status. And allow user to take note and shows in Summary View with time the nurse take the note.

Patient HomeL This shows patient's basic information and the scan button allow usert to take the photo, upload to Firestore, and change the current status.


Function folder

This folder it the file need to connect AI and APP
 
Index file is use to connect AI and app, for leting the AI be called automatically when image upload to Firebase.
 

Notes

You can use the Firebase we setup to check how we setup, but you have to setup your own one to modify and make change. 

Infomation

ChingChi Tseng: flfhx1214@gmail.com
Daniel Chang: danielchang10202@gmail.com

******************************************************************************  
