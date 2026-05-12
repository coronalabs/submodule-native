//
//  AppCoronaDelegate.mm
//  TemplateApp
//
//  Copyright (c) 2017 __MyCompanyName__. All rights reserved.
//

#import "AppCoronaDelegate.h"

#import <CoronaRuntime.h>
#import <CoronaLua.h>
#import <UIKit/UIKit.h>

// ---------------------------------------------------------------------------
// iOS 26 / Mac Catalyst window fix
//
// On iOS 26, UIWindowScene no longer retains UIWindow objects created outside
// the scene delegate. We hold a strong static reference to prevent deallocation.
//
// On iOS 26 + old UIApplicationDelegate lifecycle, runtime.appWindow is nil;
// only appViewController is provided. We create a scene-backed UIWindow,
// set the VC as its root, then force-resume after the spurious
// viewDidDisappear/pause that UIKit emits during the ForegroundInactive
// → ForegroundActive transition.
// ---------------------------------------------------------------------------

static UIWindow *gCoronaSceneWindow = nil;

static void MigrateVCToScene(UIWindow * _Nullable coronaWindow,
                              UIViewController * _Nullable coronaVC,
                              id<CoronaRuntime> runtime,
                              int attempt);

static void MigrateVCToSceneRetryIfNeeded(UIWindow * _Nullable coronaWindow,
                                          UIViewController * _Nullable coronaVC,
                                          id<CoronaRuntime> runtime,
                                          int attempt)
{
    if (attempt > 10) { return; }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
        MigrateVCToScene(coronaWindow, coronaVC, runtime, attempt);
    });
}

static void MigrateVCToScene(UIWindow * _Nullable coronaWindow,
                              UIViewController * _Nullable coronaVC,
                              id<CoronaRuntime> runtime,
                              int attempt)
{
    if (!coronaWindow && !coronaVC) { return; }

    if (@available(iOS 13.0, *)) {
        UIWindowScene *activeScene = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *ws = (UIWindowScene *)scene;
                if (ws.activationState == UISceneActivationStateForegroundActive ||
                    ws.activationState == UISceneActivationStateForegroundInactive) {
                    activeScene = ws;
                }
            }
        }

        if (!activeScene) {
            MigrateVCToSceneRetryIfNeeded(coronaWindow, coronaVC, runtime, attempt + 1);
            return;
        }

        // After makeKeyAndVisible the scene is still ForegroundInactive, so UIKit
        // sends a spurious viewDidDisappear/pause. Counter it with an explicit resume.
        void (^scheduleResume)(UIViewController *vc) = ^(UIViewController *vc) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [runtime resume];
                if ([vc respondsToSelector:@selector(resume)]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                    [vc performSelector:@selector(resume)];
#pragma clang diagnostic pop
                }
            });
        };

        // Create a scene-backed window and store a strong reference so ARC
        // (and iOS 26's scene lifecycle) does not release it prematurely.
        UIWindow *(^makeSceneWindow)(UIViewController *vc) = ^UIWindow *(UIViewController *vc) {
            UIWindow *win = [[UIWindow alloc] initWithWindowScene:activeScene];
            win.rootViewController = vc;
            [win makeKeyAndVisible];
            gCoronaSceneWindow = win;
            return win;
        };

        // Case A: explicit window, not yet scene-backed — migrate its rootVC.
        if (coronaWindow) {
            if (coronaWindow.windowScene) {
                if (coronaWindow.isHidden) { [coronaWindow makeKeyAndVisible]; }
                return;
            }
            UIViewController *rootVC = coronaWindow.rootViewController;
            if (!rootVC) { return; }
            coronaWindow.rootViewController = nil;
            makeSceneWindow(rootVC);
            scheduleResume(rootVC);
            return;
        }

        // Case B: no window — put appViewController into a new scene window.
        if (coronaVC.view.window) {
            UIWindow *existing = coronaVC.view.window;
            if (existing.windowScene) {
                if (existing.isHidden) { [existing makeKeyAndVisible]; }
                return;
            }
            existing.rootViewController = nil;
            makeSceneWindow(coronaVC);
            scheduleResume(coronaVC);
            return;
        }

        makeSceneWindow(coronaVC);
        scheduleResume(coronaVC);

    }
    // iOS < 13: no scene concept, nothing to do.
}

// ---------------------------------------------------------------------------

@implementation AppCoronaDelegate

- (void)willLoadMain:(id<CoronaRuntime>)runtime
{
    UIWindow         *appWindow = runtime.appWindow;
    UIViewController *appVC     = runtime.appViewController;

    // Defer so UIWindowScene is connected (it attaches after didFinishLaunching returns).
    dispatch_async(dispatch_get_main_queue(), ^{
        MigrateVCToScene(appWindow, appVC, runtime, 1);
    });
}

- (void)didLoadMain:(id<CoronaRuntime>)runtime
{
}

#pragma mark UIApplicationDelegate methods

// The following are stubs for common delegate methods. Uncomment and implement
// the ones you wish to be called. Or add additional delegate methods that
// you wish to be called.

/*
- (void)applicationWillResignActive:(UIApplication *)application
{
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
*/

/*
- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
*/

/*
- (void)applicationWillEnterForeground:(UIApplication *)application
{
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
*/

/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
*/

/*
- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
*/

@end
