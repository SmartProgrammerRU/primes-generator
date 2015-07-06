#import "PGHistoryViewController.h"

static NSInteger  const nextButtonTag = 1;
static NSString  *const cellIdentifier = @"ResultCell";
static NSString  *const kUserEnterANumber = @"Пользователь вводит:";
static NSString  *const kNumberList = @"Список чисел:";
static CGRect     const kHeaderFrame = {{0.f, 0.f}, {320.f, 43.f}};
static NSString  *const kHorizontalConstraint = @"H:|-16-[label]-16-|";
static NSString  *const kVerticalConstraint = @"V:|-0-[label]-0-|";

@interface PGHistoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *generatedNumbers;
@property (strong, nonatomic) NSNumber *limit;
@property (nonatomic) NSInteger actualSelectedNumber;

@end

@implementation PGHistoryViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   self.navigationController.navigationBarHidden = NO;
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
   
   UIBarButtonItem *prevSearchButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"prev search"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(showNextResult:)];
   
   UIBarButtonItem *nextSearchButton = [[UIBarButtonItem alloc]
                                        initWithTitle:@"next search"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(showNextResult:)];
   nextSearchButton.tag = nextButtonTag;
   
   self.navigationItem.rightBarButtonItems = @[nextSearchButton, prevSearchButton];
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   self.navigationController.navigationBarHidden = YES;
}

- (void)setActualSelectedNumber:(NSInteger)actualSelectedNumber
{
   _actualSelectedNumber = actualSelectedNumber;
   
   self.limit = self.cachedHistory.searchedNumbers[actualSelectedNumber];
   self.generatedNumbers = [self.cachedHistory parseToTableViewReadableData:self.cachedHistory.largestGeneratedNumbersArray
                                                                        key:self.limit];
}

- (void)updateUI:(NSInteger)page
{
   self.actualSelectedNumber = page;
   [self.tableView reloadData];
}

- (void)showNextResult:(id)sender
{
   if ([sender isKindOfClass:[UIBarButtonItem class]]) {
      UIBarButtonItem *button = (UIBarButtonItem *)sender;
      NSInteger resultToShow;
      
      if (button.tag == nextButtonTag) {
         resultToShow = self.actualSelectedNumber + 1;
      } else {
         resultToShow = self.actualSelectedNumber - 1;
      }
      
      if (resultToShow < 0 || resultToShow > [self.cachedHistory.searchedNumbers count]-1) {
         return;
      }
      
      [self updateUI:resultToShow];
   }
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.generatedNumbers count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if (![self.cachedHistory.searchedNumbers count]) {
      return nil;
   }
   
   UIView *headerView = [[UIView alloc] initWithFrame:kHeaderFrame];
   headerView.backgroundColor = [UIColor lightGrayColor];
   
   UILabel *label = [[UILabel alloc] init];
   label.translatesAutoresizingMaskIntoConstraints = NO;
   label.numberOfLines = 0;
   label.text = [NSString stringWithFormat:@"%@ %@\n%@", kUserEnterANumber, self.limit, kNumberList];
   [headerView addSubview:label];
   
   NSDictionary *viewsDictionary = @{@"label":label};
   NSArray *constraints =
   [NSLayoutConstraint constraintsWithVisualFormat:kHorizontalConstraint
                                           options:0 metrics:nil views:viewsDictionary];
   NSArray *constraints2 =
   [NSLayoutConstraint constraintsWithVisualFormat:kVerticalConstraint
                                           options:0 metrics:nil views:viewsDictionary];
   [headerView addConstraints:constraints];
   [headerView addConstraints:constraints2];
   
   return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
   
   if (!cell) {
      cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
   }
   
   cell.backgroundColor = [UIColor clearColor];
   cell.textLabel.textAlignment = NSTextAlignmentCenter;
   cell.textLabel.text = [NSString stringWithFormat:@"%@", self.generatedNumbers[indexPath.row]];
   
   return cell;
}

@end