@import Foundation;

@class BSTNotificationOptionsBuilder;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BSTNotificationOptionsBuilderBlock)(BSTNotificationOptionsBuilder *builder);

@interface BSTNotificationOptions : NSObject

@property (nonatomic, copy, readonly, nullable) NSDictionary *userInfo;
@property (nonatomic, copy, readonly, nullable) NSString *categoryIdentifier;

@end

@interface BSTNotificationOptions (Builder)

+ (instancetype)notificationOptionsWithBlock:(BSTNotificationOptionsBuilderBlock)block;

@end

@interface BSTNotificationOptionsBuilder : NSObject

@property (nonatomic, copy, readwrite, nullable) NSDictionary *userInfo;
@property (nonatomic, copy, readwrite, nullable) NSString *categoryIdentifier;

- (BSTNotificationOptions *)build;

@end

NS_ASSUME_NONNULL_END
