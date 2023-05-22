@import UIKit;

NS_ASSUME_NONNULL_BEGIN

@interface BSTCampaignEntryView : UIView

@property (nonatomic, strong, readwrite) NSArray<UIView *> *clickableViews;

- (void)setEntryName:(NSString *)entryName;

@end

NS_ASSUME_NONNULL_END
