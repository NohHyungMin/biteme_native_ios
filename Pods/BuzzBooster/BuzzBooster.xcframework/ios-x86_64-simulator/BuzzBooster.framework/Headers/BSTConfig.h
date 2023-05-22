@import Foundation;

@class BSTConfigBuilder;
@class BSTNotificationOptions;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BSTConfigBuilderBlock)(BSTConfigBuilder *builder);

@interface BSTConfig : NSObject

@property (nonatomic, copy, readonly) NSString *appKey;
@property (nonatomic, strong, readonly, nullable) BSTNotificationOptions *notificationOptions;

@end

@interface BSTConfig (Builder)

+ (instancetype)configWithBlock:(BSTConfigBuilderBlock)block;

@end

@interface BSTConfigBuilder : NSObject

@property (nonatomic, copy, readwrite) NSString *appKey;
@property (nonatomic, strong, readwrite, nullable) BSTNotificationOptions *notificationOptions;

- (BSTConfig *)build;

@end

NS_ASSUME_NONNULL_END
