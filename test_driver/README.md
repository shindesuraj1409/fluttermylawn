# **My Lawn Flutter integration test.**
We are using **Flutter Driver** for creating E2E test for MyLawn application. 

## **Prerequisite:**
* Follow the steps from main root-level README.md file and setup the MyLawn project successfully.
* Switch to particular branch where you want to run scripts.
* Some tests run python scripts. Hence, **Python3** and **pip3** must be installed in your computer.
* For email parsing in some tests you need to define `credentials.json` under `test_driver` folder in the following format:

File path : test_driver/credentials.json

```
{
    "email": "<Add_Email_Id>",
    "password": "<Add_Password>",
    "from_email": "<Add_From_Email>",
    "mail_server": "<Add_Mail_Server>",
    "search_string" : <Add_String_To_Search_Email_Body>
}
```

## Gmail configuration
*  Gmail settings - allow less secure apps

* Set up IMAP
    1. On your computer, open Gmail.
    2. In the top right, click Settings. See all settings.
    3. Click the Forwarding and POP/IMAP tab.
    4. In the "IMAP access" section, select Enable IMAP.
    5. Click Save Changes.



_**NOTE:** Use command `git branch` to get list of all available branches and use `git checkout <branch-name>` to checkout to particular branch._
* Connect any Android physical device or start iOS simulator and execute: `flutter run`, it should install the application on connected device/simulator successfully.

## **Test execution on local devices:**
### <u>NOTES</u>
_**NOTE-1:** If multiple devices connected, it will ask you to select a particular device_

_**NOTE-2:** `flutter run` command is not mandatory to run, you can directly run the `flutter drive --target="<path_to_test>" <optional_api_keys_arguments>` it will anyway compile and build the application first before executing the tests_

_**NOTE-3:** `flutter drive --target="<path_to_test>" <optional_api_keys_arguments> --no-build` will run the command without compiling & building an app so it is faster, it uses the existing pre-created build, so make sure to build the app, before using this command_ 

_**NOTE-4:**  For some end-to-end scenarios we need to pass the `<optional_api_keys_arguments>` without it Google Map and Location fields won't work in the app._

_**NOTE-5:** There are 2 test files written for the same test. One file with `_test.dart` name and other file won't have it. While executing the test make sure you're running file without having `_test.dart` name_

### 1) Android
1) Connect real **Android** to your local machine, verify it is connected properly via `adb devices` command (it should return the device id).

2) Execute `flutter run` in first terminal. 
- _If there are multiple devices connected, then it will ask to select the device upon which you want to run the application:_
![multiple-devices](https://drive.google.com/uc?export=view&id=1K7Gtg7-hJFATOFE7yCUvgjWXthpo8-pT)
- _Successful o/p looks like:_
![flutter run](https://drive.google.com/uc?export=view&id=1mpmaKiGN6S3WAkpIlfPV2kS87UAhCd-K)

3) Execute `flutter drive --target="<path_to_test>" <optional_api_keys_arguments>` in second terminal to run specific test.
- For example: `flutter drive --target="test_driver/tests/splash_screen.dart"` will execute splash_screen test.
![example-test](https://drive.google.com/uc?export=view&id=1wYwuLp9EEzEd-oCWGwnIF0ySCQCG5wnj)

4) To execute all tests, execute this command `./automation-integration-test.sh`.

### 2) iOS
#### Steps for real iPhone device setup:
_**NOTE:** Below steps are one time activity for newly connected/registered physical iPhone device_ 
1) Connect real **iPhone** to your local machine
- _**NOTE-1:** When you connect iPhone first time to your machine, a pop up will appear on iOS device, so tap on **Trust**_ 
- _**NOTE-2:** If multiple devices connected, it will ask you to select a particular device, choose the real iPhone device from list_ 

2) Open `ios/Runner.xcworkspace` on XCode

3) Move to XCode > Preferences > Accounts and add your apple developer ac. _(Make sure you have enough permissions for Scotts apple developer ac., contact Paul/Derek if you don't have)_
![apple-ac](https://drive.google.com/uc?export=view&id=1vulWNAQhm-EghP_KmtwompWNwfyUheVd)

4) Select Runner in file hierarchy

5) Select your connected iPhone as device
![select-device](https://drive.google.com/uc?export=view&id=1H7WSoumqu1PXZm-KvvAYGvqwYrcvuGUh)

6) Select Runner as target and click on Signing & Capabilities
![signing](https://drive.google.com/uc?export=view&id=1I79e6drOJhWQWt6dfGgzpFgf3smc1ivd)

7) Check the "Automatically manage signing"  ![enable-signing](https://drive.google.com/uc?export=view&id=1vTU_b_J6_CLlVGEucvNn0jJM8u09k_WX)

8) Now click on "Register Device" to register your iPhone with Scotts apple developer ac. (One time activity)
![register-new-device](https://drive.google.com/uc?export=view&id=1UXIs-KYb6_XoENu3kCnKIurQq6a9roJs)

9) Now all is set for iOS, try to run the application by clicking on Play button from XCode 

10) Similiarly try to run `flutter run` and see application is being installed

#### Steps for test execution (Real iOS device/Simulator):
1) Move to root directory and do execute `flutter drive --target="<path_to_test>" <optional_api_keys_arguments>` 
_For example: `flutter drive --target="test_driver/tests/manual_entry_screen.dart"` will execute manual_entry_screen test._
- _**NOTE:** Use `--no-build` flag to save build time, but make sure application is installed first_

2) To execute all tests, execute this command `./automation-integration-test.sh`.


## Limitations
- Bulk test suite runs are not supported as of now, we need to add a method to clear/reset app storage OR reinstall the app), so please uninstall/clear app storage manually after every test run
