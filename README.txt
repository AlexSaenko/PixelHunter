Features:
1) Standard 50-pixel grid
2) 1-pixel grid while zoom to max
3) Interactive rulers
4) Upload mockup from gallery to compare
5) Different marking notes
6) Mail sharing


Integration guide:
1) Add CoolTool folder to project
2) Go to AppDelegate.m 
3) Make an import: #import “SUCoolTool.h”
4) In method - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions write this line: [SUCoolTool setup];
5) Go to Project > Choose target > Build Phases > Link Binary With Libraries.
6) Add “AVFoundation.framework”, “MessageUI.framework” and “CoreGraphics.framework”
6) Run application on device
7) Shake device
8) Draw Z on screen
9) Enjoy!