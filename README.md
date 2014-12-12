# Todo List 

Todo List is a simple task management app built upon the Bitcasa CloudFS platform SDK which helps you keep track of activities that need to be done in real life. Using this app you can add tasks to your to do list and mark them as done once you are done with them or edit them if the tasks change and delete these tasks when they are no longer relevant.
This implementation of the Todo List has been done using the [CloudFS iOS](https://github.com/bitcasa/CloudFS-iOS) SDK on [iOS](http://developer.apple.com). 



## Installation

### 1. Download
First you need to clone the *ToDoList-iOS* project files to your workspace:

    $ cd /path/to/your/workspace
    $ git clone https://github.com/bitcasa/ToDoList-iOS.git projectname
    $ cd projectname

### 2. Requirements
* iOS SDK 8.0 or above.
* Xcode 6 or above.

### 3. Tweaks
#### CloudFS Settings
For you to use the Todo List app with CloudFS, you need to enter your CloudFS related credentials in the app configuration file. The file location and the related settings are as follows:

    $ \TodoList\Resources\BitcasaConfig.plist

```   
<plist version="1.0">
<dict>
    <key>BC_API_SERVER_URL</key>
    <string>xxxx</string>
    <key>BC_CLIENT_ID</key>
    <string>xxxx</string>
    <key>BC_SECRET</key>
    <string>xxxx</string>
    <key>BC_USER_REGISTRATION_URL</key>
    <string>xxxx</string>
    <key>BC_USER_AUTH_URL</key>
    <string>xxxx</string>
</dict>
</plist>
```

More information on these variables and account creation can be found in our ToDoList-iOS [documentation](#)

### 4. Start development
Once all these steps are carried out you will be able to start tweaking and changing the app to discover the posibilities provided by the CloudFS SDK and iOS.
