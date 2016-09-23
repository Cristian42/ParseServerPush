# Parse Server with Push in AWS + Swift iOS Starter App
### Quick 10-minute guide to:
  * Deploy Parse Server on AWS Elastic Beanstalk
  * Enable Parse Server Push Notifications
  * Write Cloud Code to handle Client Push Notifications
  * Register new Swift iOS app with Parse Server using CocoaPods
  * Save objects, send and receive push notifications with Parse SDK for Swift/iOS

Links:
  * [Parse.com iOS](http://parseplatform.github.io/docs/ios/guide/)
  * [AWS Elastic Beanstalk](https://console.aws.amazon.com/elasticbeanstalk)
  * [MongoLab](https://mlab.com/)
  * [Apple Developer Center](https://developer.apple.com/membercenter/index.action)

Guides:
  * [Parse.com Complete Push Guide](https://webcache.googleusercontent.com/search?q=cache:EUSCtaCYVLAJ:https://parse.com/tutorials/push-notifications)
  * [AWS Blog: Deploy Parse Server on AWS](https://mobile.awsblog.com/post/TxCD57GZLM2JR/How-to-set-up-Parse-Server-on-AWS-using-AWS-Elastic-Beanstalk)

Code & Docs:
  * [Parse.com on Github](https://github.com/ParsePlatform)
  * [Parse SDK for iOS](https://github.com/ParsePlatform/Parse-SDK-iOS-OSX)
  * [Parse Server Repo](https://github.com/ParsePlatform/parse-server)
  * [Parse Dashboard Repo](https://github.com/ParsePlatform/parse-dashboard)
  * [Parse Server on Express Repo](https://github.com/ParsePlatform/parse-server-example)
  * [AWS Docs: Elastic Beanstalk Getting Started](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/GettingStarted.html)
  * [AWS Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html)
  * [Parse Server Push Wiki](https://github.com/ParsePlatform/Parse-Server/wiki/Push)

## 1. Create Push-Enabled AppID and certificates in Apple Developer Center

[Full Guide](https://webcache.googleusercontent.com/search?q=cache:EUSCtaCYVLAJ:https://parse.com/tutorials/push-notifications)

1. Go to [Apple Developer Center](https://developer.apple.com/membercenter/index.action)

2. Go to Developer Center > Certificates, Identitfiers & Profiles > Identifiers > App IDs > Create a new one with Push Notifications enabled. Write down the BundleID (will need to write it in XCode to make our app push notification-enabled)

3. Go to AppIDs > Select the AppID created above > Application Services > Edit > Push Notifications > Production SSL Certificate > Create Certificate. Create and download it > Double click to open in KeyChain > Right click on it (and not on its subitem) > Export > Save as .p12. Save the .p12 file (will pass it to Parse Server to be able to send push notifications to Apple's Push Notification Service)

## 2. Deploy a Parse Server on AWS Elastic Beanstalk
[Full Guide](https://mobile.awsblog.com/post/TxCD57GZLM2JR/How-to-set-up-Parse-Server-on-AWS-using-AWS-Elastic-Beanstalk)
  * [AWS Elastic Beanstalk](https://console.aws.amazon.com/elasticbeanstalk)
  * parse-server: https://github.com/ParsePlatform/parse-server
  * parse-server on Express: https://github.com/ParsePlatform/parse-server-example

### 1. Start the Parse Server on AWS Elastic Beanstalk **with the 1-Click Deploy to AWS Button**:

  <a title="Deploy to AWS" href="https://console.aws.amazon.com/elasticbeanstalk/home?region=us-east-1#/newApplication?applicationName=ParseServer&solutionStackName=Node.js&tierName=WebServer&sourceBundleUrl=https://s3.amazonaws.com/elasticbeanstalk-samples-us-east-1/eb-parse-server-sample/parse-server-example.zip" target="_blank"><img src="http://d0.awsstatic.com/product-marketing/Elastic%20Beanstalk/deploy-to-aws.png" height="40"></a>

 * Make sure you choose the desired region

 * Link: [AWS Elastic Beanstalk](https://console.aws.amazon.com/elasticbeanstalk)

#### To check that your server works correctly:
  * Log in to [AWS Elastic Beanstalk](https://console.aws.amazon.com/elasticbeanstalk)
  * Click on your URI, e.g. `http://***.***.elasticbeanstalk.com/` Make sure it is online
  * Check `/parse` e.g. `http://***.***.elasticbeanstalk.com/parse`. You should see `{"error":"unauthorized"}` if everything works correctly.

#### To download the code locally, make changes later and re-deploy:
  * Create a directory for your project and change your working directory into that directory.
  * Log in with the [AWS Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html). Set your PATH with `export PATH=~/.local/bin:$PATH`
  * Run `eb init` to log in and select the application you created through the quick launch link.
  * Run `eb labs download`. This  will download the code that is running on the AWS Elastic Beanstalk environment to your local folder.
  * Make necessary changes to the code.
  * Deploy the code with `eb deploy` (or `eb deploy --staged` with git) [Aws Docs: eb with git](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb3-cli-git.html)

### 2. Set up a Mongo Instance

4. Sign up at www.mlab.com. Create a new database (First 500Mb are free in Sandbox) and a new user in it. Write down the database URI.

### 3. Configure the AWS Elastic Beanstalk Parse Server
Configure the Elastic Beanstalk to use the `mongodb://` URI, generate 2 random strings for `APP_ID` and `MASTER_KEY`, and set the `SERVER_URL` to the one at the top of the page)

  * Click on: https://console.aws.amazon.com/elasticbeanstalk
  * Go to: Application > Configuration > Software Configuration > Environment Properties > Set `APP_ID` etc.


## 3. Configure the Parse Server for Push

[Full Guide](https://github.com/ParsePlatform/Parse-Server/wiki/Push)
  * [AWS Elastic Beanstalk CLI](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html). To set path use `export PATH=~/.local/bin:$PATH`
 
1. Download the server code using the steps above:
  * `export PATH=~/.local/bin:$PATH` (if needed)
  * `eb init`
  * `eb labs download`

2. Edit `index.js` file. Add `push: { }` to the ParseServer object.

  ```
  var api = new ParseServer({
    databaseURI: '...',
    cloud: '...',
    appId: '...',
    masterKey: '...',
    push: {
     ios: {
       pfx: __dirname + '/cert/ParsePush.p12',
       passphrase: '', // optional password to your p12/PFX
       bundleId: process.env.BUNDLE_ID || '',
       production: process.env.PUSH_PRODUCTION || true
     }
   }
  });
```
3. Copy the `.p12` file to this folder (or a subfolder) and set the pfx path to point to it.

4. Add the env variables in `.ebextensions/app.config` :
  ```
option_settings:
  aws:elasticbeanstalk:application:environment:
    ...
    BUNDLE_ID: "bundleID"
    PUSH_PRODUCTION: "true"
```
5. Add CloudCode to handle Client Push notifications in `cloud/main.js`:
  ```
Parse.Cloud.define("sendPushToChannels", function(request, response) {

  var channels = request.params.channels;
  var message = request.params.message;
 
  // Send the push notification to the selected channels
  Parse.Push.send({
    channels: channels,
    data: {
      alert: message
    }
  }, { useMasterKey: true }
  ).then(function() {
      response.success("Push was sent successfully.")
  }, function(error) {
      response.error("Push failed to send with error: " + error.message);
  });

});
```

6. Run: `git add index.js cert/ParsePush.p12 .ebextensions/app.config cloud/main.js`
7. Run: `eb deploy --staged`
8. Go to https://console.aws.amazon.com/elasticbeanstalk/ and add valid BUNDLE_ID and PUSH_PRODUCTION env variables for your app for the server to work
9. Check your server

If you get a `502 Bad Gateway Nginx` error after adding the push configuration, it most probably means that the nodejs app cannot start (and won't respond to requests). This can occur when the app initialization throws an exception, which happens, for instance, if the push adapter cannot authenticate with the Apple APNs using the provided .p12 file, bundleID and production setting combination. Make sure they match a valid certificate (and you didn't misspell something). Debug any other issues with `eb logs`.


## 4. Configure the iOS app to use Parse Server and Push
[Parse SDK for iOS](https://github.com/ParsePlatform/Parse-SDK-iOS-OSX)

1. Create a Single-View Application in XCode

2. Set the Parse dependency. With CocoaPods: `pod 'Parse'` 
  *  If you don't have CocoaPods yet, install it with: `sudo gem install cocoapods`
  * `cd` to your XCode app folder
  * Run: `pod init`
  * Run: `open Podfile`
  * Add `pod 'Parse'` between `target App do` and `end`
  * Run `pod install`
  * Open the `.xcworkspace` file

3. Change the Bundle Identifier to the Push-enabled one

4. Open `Info.plist`. Add the `NSAppTransportSecurity` dictionary and then create the `NSAllowsArbitraryLoads` item within that with a boolean value of `YES`

4. In `AppDelegate.swift`:

  ```
import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
	// Register with Parse Server
        let configuration = ParseClientConfiguration {
            $0.applicationId = "***"
            $0.clientKey = ""
            $0.server = "http://***.***.elasticbeanstalk.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
	// Register for remote notifications
        let userNotificationTypes: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: userNotificationTypes, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
        
    }

    // Save currentInstallation object
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        if let installation = PFInstallation.currentInstallation() {
            installation.setDeviceTokenFromData(deviceToken)
            installation.channels = ["global"]
            installation.saveInBackground()
            print("Saved installation")
        } else {
            print("Failed to save installation")
        }
    }
    
    // Received remote notification when the app is on the screen. Show a simple alert message using PFPush.handlePush()
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        print("## Received a new push notification:")
        print(userInfo)
    }
   
 
// ... Keep the remaining function stubs unchanged ...

}
```

5. In `ViewController.swift`:

 ```
import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gameScore = PFObject(className:"GameScore")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("Successfuly saved object to Parse Server")
            } else {
                print("Failed saving object to Parse Server")
                print(error)
            }
        }

        let parameters = ["channels": ["global"], "message": "Hurray!"]
        PFCloud.callFunctionInBackground("sendPushToChannels", withParameters: parameters) {
            (response: AnyObject?, error: NSError?) -> Void in
            if (error == nil) {
                print("Successfuly sent Push Notification to Parse Server")
            } else {
                print("Failed sending Push Notification to Parse Server")
                print(error)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
```

7. Compile & run. If all goes well, you should see in the console:

  ```
Saved installation
Successfuly saved object to Parse Server
Successfuly sent Push Notification to Parse Server
## Received a new push notification:
[aps: {
    alert = "Hurray!";
}]
```

  And see a message displayed on the screen with the Push Notification just sent. To get the message you need to run the App on a real device (the Simulator doesn't receive push notifications)

### Install the Parse Dashboard:

[Parse Dashboard Repo](https://github.com/ParsePlatform/parse-dashboard)

1. Install with `npm`: `npm install -g parse-dashboard`

2. Run: `parse-dashboard --appId *** --masterKey *** --serverURL "http://***.***.elasticbeanstalk.com/parse" --appName optionalName`

3. Access the Dashboard at: `http://localhost:4040/`

  Push Notifications are enabled in the Dashboard as well.
