## Features
1) Standard 50-pixel grid
2) 1-pixel grid while zoom to max
3) Interactive rulers
4) Upload mockup from gallery to compare
5) Different marking notes
6) Mail sharing


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