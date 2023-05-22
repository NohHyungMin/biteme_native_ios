@import Foundation;

typedef NS_ENUM(NSInteger, BSTMarketingStatus) {
  BSTMarketingStatusUndetermined,
  BSTMarketingStatusOptIn,
  BSTMarketingStatusOptOut,
};

@class BSTUserBuilder;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BSTUserBuilderBlock)(BSTUserBuilder *builder);

@interface BSTUser : NSObject

@property (nonatomic, assign, readonly) NSString *userId;
@property (nonatomic, assign, readonly) BSTMarketingStatus marketingStatus;
@property (nonatomic, strong, readonly) NSDictionary<NSString *, NSString *> *properties;

@end

@interface BSTUser (Builder)

+ (instancetype)userWithBlock:(BSTUserBuilderBlock)block;

@end

@interface BSTUserBuilder : NSObject

@property (nonatomic, assign, readwrite) NSString *userId;
@property (nonatomic, assign, readwrite) BSTMarketingStatus marketingStatus;
@property (nonatomic, strong, readwrite) NSDictionary<NSString *, NSString *> *properties;

- (BSTUser *)build;

@end

NS_ASSUME_NONNULL_END
