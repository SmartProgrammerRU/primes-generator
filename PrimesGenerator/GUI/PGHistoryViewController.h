#import <UIKit/UIKit.h>
#import "PGGenerator.h"

@interface PGHistoryViewController : UIViewController

@property (strong, nonatomic) PGSearchHistory *cachedHistory;

- (void)updateUI:(NSInteger)page;

@end