This library presents User Interface verifying tool for iOS applications which appears by specific gesture. It helps to detect differences between designers mock-ups and real application. The library could be embedded to an application during development stage and might be useful for project managers, QA engineers and software development engineers.


## Features
-  Standard 50-pixel grid
-  1-pixel grid while zoom to max
-  Interactive rulers
-  Upload mockup from gallery to compare
-  Different marking notes
-  Mail sharing


## How To Get Started
-  Add CoolTool folder to project
-  Go to AppDelegate.m 
-  Make an import:

```objective-c
#import “SUCoolTool.h”
```

-  In method 

```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
```

write this line: 

```objective-c
[SUCoolTool setup];
```

-  Go to Project > Choose target > Build Phases > Link Binary With Libraries.
-  Add “AVFoundation.framework”, “MessageUI.framework” and “CoreGraphics.framework”
-  Run application on device
-  Shake device
-  Draw Z on screen
-  Enjoy!
