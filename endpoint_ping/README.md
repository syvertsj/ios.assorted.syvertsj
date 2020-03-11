# iOS: Endpoint Ping

syvertsj

Usage:
1. enter url in text field
2. press "submit ping" button
3. results displayed in output text field 
4. clear button clears output text field

This application makes use of the following:
- UITextFieldDelegate methods
- "PlainPing" cocoapod library to test endpoint reachability and response

Setup: 
- run *pod init* to generate Podfile
- add *pod "PlainPing"* to Podfile 
- run *pod install* 
- close and restart Xcode selecting the xcworkspace virtual folder
