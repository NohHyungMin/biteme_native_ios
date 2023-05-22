@import UIKit;
@import UserNotifications;
#import <BuzzBooster/BSTConfig.h>
#import <BuzzBooster/BSTNotificationOptions.h>
#import <BuzzBooster/BSTUser.h>
#import <BuzzBoosterSwift/BSTCustomCampaignDelegate.h>
#import <BuzzBoosterSwift/BSTOptInMarketingCampaignDelegate.h>
#import <BuzzBoosterSwift/BSTCampaignEntryView.h>
#import <BuzzBoosterSwift/BuzzBoosterSwift.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuzzBooster : NSObject

+ (void)initializeWithConfig:(BSTConfig *)configs;

+ (void)setUser:(nullable BSTUser *)user;

+ (void)setCustomCampaignDelegate:(id<BSTCustomCampaignDelegate>)customCampaignDelegate;

+ (void)setOptInMarketingCampaignDelegate:(id<BSTOptInMarketingCampaignDelegate>)optInMarketingCampaignDelegate;

+ (void)setDeviceToken:(NSData *)token;

+ (void)setPushToken:(NSString *)token;

+ (void)sendEventWithEventName:(NSString *)eventName;

+ (void)sendEventWithEventName:(NSString *)eventName
                   eventValues:(NSDictionary<NSString*, NSString*> *)eventValues;

+ (void)startService;

+ (void)showCampaignWithViewController:(UIViewController *)viewController;

+ (void)showCampaignWithViewController:(UIViewController *)viewController
                            campaignId:(NSString *)campaignId;

+ (void)showCampaignWithViewController:(UIViewController *)viewController
                                  type:(BSTCampaignType)type;

+ (void)showInAppMessageWithViewController:(UIViewController *)viewController;

+ (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler;

+ (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void(^)(void))completionHandler;

@end

NS_ASSUME_NONNULL_END
