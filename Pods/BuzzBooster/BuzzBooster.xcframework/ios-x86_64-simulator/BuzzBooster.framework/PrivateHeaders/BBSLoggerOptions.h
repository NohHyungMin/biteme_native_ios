@import Foundation;

@protocol BBSLoggerEventProcessorProtocol;
@class BBSLoggerOptionsBuilder;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BBSLoggerOptionsBuilderBlock)(BBSLoggerOptionsBuilder *builder);

@interface BBSLoggerOptions : NSObject

@property (nonatomic, assign, readonly) BOOL isEnable;
@property (nonatomic, strong, readonly) NSArray<id<BBSLoggerEventProcessorProtocol>> *eventProcessors;

@end

@interface BBSLoggerOptions (Builder)

+ (BBSLoggerOptions *)optionsWithBlock:(BBSLoggerOptionsBuilderBlock)block;

@end

@interface BBSLoggerOptionsBuilder : NSObject

@property (nonatomic, assign, readwrite) BOOL isEnable;

- (void)installEventProcessor:(id<BBSLoggerEventProcessorProtocol>)eventProcessor;

- (BBSLoggerOptions *)build;

@end

NS_ASSUME_NONNULL_END
