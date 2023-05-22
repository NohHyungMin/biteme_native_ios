@import Foundation;

@class BBSLoggerEvent;

NS_ASSUME_NONNULL_BEGIN

@protocol BBSLoggerEventProcessorProtocol <NSObject>

- (void)processEvent:(BBSLoggerEvent *)event;

@end

NS_ASSUME_NONNULL_END
