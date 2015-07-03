#import <UIKit/UIKit.h>
#import "PGSeachResult.h"

@interface PGHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *cachedResults;

@end