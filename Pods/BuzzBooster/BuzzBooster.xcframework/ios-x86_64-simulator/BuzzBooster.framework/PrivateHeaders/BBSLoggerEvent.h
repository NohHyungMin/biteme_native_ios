@import Foundation;

@class BBSLoggerEventBuilder;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BBSLoggerEventBuilderBlock)(BBSLoggerEventBuilder *builder);

@interface BBSLoggerEvent : NSObject

@property (nonatomic, copy, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSString *message;

@end

@interface BBSLoggerEvent (Builder)

+ (BBSLoggerEvent *)eventWithBlock:(BBSLoggerEventBuilderBlock)block;

@end

@interface BBSLoggerEventBuilder : NSObject

@property (nonatomic, assign, readwrite) NSDate *date;
@property (nonatomic, copy, readwrite) NSString *message;

- (BBSLoggerEvent *)build;

@end

NS_ASSUME_NONNULL_END
