#import <UIKit/UIKit.h>

// گۆڕینی ناسنامەی مۆبایل بۆ تێپەڕاندنی باند
%hook UIDevice
- (NSUUID *)identifierForVendor {
    return [[NSUUID alloc] initWithUUIDString:@"550E8400-E29B-41D4-A716-446655440000"];
}
%end

// دروستکردنی نامەی بەخێرھاتن و سیستەمی چالاککردن
%hook SnapchatAppDelegate
- (bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
    bool result = %orig;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *window = [UIApplication sharedApplication].windows.firstObject;

        UIAlertController *welcomeAlert = [UIAlertController alertControllerWithTitle:@"Fly Store" 
            message:@"بەخێر بێیت بۆ سناپی فڵای ستۆر\nئەم سناپە تایبەتکراوە بۆ بەکارهێنەرانی فڵای ستۆر" 
            preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *thanksAction = [UIAlertAction actionWithTitle:@"سوپاس" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            UIAlertController *keyAlert = [UIAlertController alertControllerWithTitle:@"چالاککردن" 
                message:@"تکایە کۆدی تایبەت بنوسە بۆ چوونە ژوورەوە" 
                preferredStyle:UIAlertControllerStyleAlert];
            
            [keyAlert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                textField.placeholder = @"کۆدەکە لێرە بنوسە...";
                textField.secureTextEntry = YES;
            }];
            
            UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"داخلبوون" style:UIAlertActionStyleDefault handler:^(UIAlertAction *loginAct) {
                NSString *userKey = keyAlert.textFields[0].text;
                
                // پشکنینی کۆدەکە لەگەڵ سێرڤەری فڵای ستۆر
                NSString *urlStr = [NSString stringWithFormat:@"http://209.38.193.20:5000/verify?key=%@", userKey];
                NSURL *url = [NSURL URLWithString:urlStr];
                
                NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    if (data) {
                        NSString *resStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        if ([resStr containsString:@"success"]) {
                            // کۆدەکە ڕاستە و بەرنامەکە دەکرێتەوە
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                exit(0); // کۆدەکە هەڵەیە و بەرنامەکە دادەخرێت
                            });
                        }
                    } else {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            exit(0);
                        });
                    }
                }];
                [task resume];
            }];
            
            [keyAlert addAction:loginAction];
            [window.rootViewController presentViewController:keyAlert animated:YES completion:nil];
        }];
        
        [welcomeAlert addAction:thanksAction];
        [window.rootViewController presentViewController:welcomeAlert animated:YES completion:nil];
    });
    
    return result;
}
%end
