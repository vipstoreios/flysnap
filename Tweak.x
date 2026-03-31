#import <UIKit/UIKit.h>

%hook UIDevice
- (NSUUID *)identifierForVendor {
    return [[NSUUID alloc] initWithUUIDString:@"550E8400-E29B-41D4-A716-446655440000"];
}
%end

%hook SnapchatAppDelegate
- (bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    bool result = %orig;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Fly Store" 
            message:@"سڵاو لە بەکارهێنەرانی فڵای ستۆر\nئەم بەرنامەیە بە سەرکەوتوویی چالاک بوو" 
            preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"سوپاس" style:UIAlertActionStyleDefault handler:nil]];
        [window.rootViewController presentViewController:alert animated:YES completion:nil];
    });
    return result;
}
%end
