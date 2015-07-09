#import "PGMainViewController.h"
#import "PGHistoryViewController.h"

static NSString *const cellIdentifier = @"MyCell";
static NSString *const kHistorySegue =  @"showHistory";
static NSString *const kNumberSet = @"0123456789";
static NSInteger const kAvailableTextLength = 7;

@interface PGMainViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *inputField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listHeightConstraint;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) NSArray *generatedNumbers;
@property (nonatomic, getter=isGenerating) BOOL generating;

@end

@implementation PGMainViewController

#pragma mark - Lifecycle

- (void)viewWillLayoutSubviews
{
   self.inputWidthConstraint.constant = self.view.frame.size.width / 3;
   self.listHeightConstraint.constant = self.view.frame.size.height * 2 / 3;
}

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
}


#pragma mark - Private Section

- (BOOL)isGenerating
{
   return [self.indicatorView isAnimating];
}

- (void)showSpinning
{
   [self.indicatorView startAnimating];
}

- (void)hideSpinning
{
   [self.indicatorView stopAnimating];
}

- (void)refreshUI
{
   [self.tableView reloadData];
}

- (void)startGeneratingWithNumber:(NSString *)number
{
   if (self.isGenerating | ![number length]) {
      return;
   }
   
   [self showSpinning];
   dispatch_async(dispatch_get_global_queue(0, 0), ^{
      /* improved generator algorithm */
      self.generatedNumbers = [PGGenerator generatePrimesOddMultiThreaded:[number longLongValue]];
      [self cacheTheResults];
      dispatch_async(dispatch_get_main_queue(), ^{
         [self hideSpinning];
         [self refreshUI];
      });
   });
}

- (void)cacheTheResults
{
   [PGGenerator saveResults:self.generatedNumbers forNumber:self.inputField.text];
}


#pragma mark - Actions

- (IBAction)generateNumbers:(id)sender
{
   [self.inputField resignFirstResponder];
   [self startGeneratingWithNumber:self.inputField.text];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   if ([[segue identifier] isEqualToString:kHistorySegue]) {
      PGHistoryViewController *hvc = (PGHistoryViewController *)[segue destinationViewController];
      dispatch_async(dispatch_get_global_queue(0, 0), ^{
         /* improved work with memory */
         hvc.cachedHistory = [PGGenerator loadCachedResults];
         dispatch_async(dispatch_get_main_queue(), ^{
            [hvc updateUI:0];
         });
      });
   }
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.generatedNumbers count];
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


#pragma mark - UITextField Section

- (BOOL)isDecimalNumber:(NSString *)numberString
{
   NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:kNumberSet];
   NSCharacterSet *nonNumberSet = [numberSet invertedSet];
   BOOL correctInput = ([numberString rangeOfCharacterFromSet:nonNumberSet].location == NSNotFound);
   
   return correctInput;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   [self generateNumbers:nil];
   return [textField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   // prevent cheating, allow only decimal numbers
   BOOL isInputCorect = [self isDecimalNumber:string];
   
   // for testing purposes let's a number will be within  [2 ; 10 000 000)
   if ([textField.text length] >= kAvailableTextLength && ![string isEqualToString:@""]) {
      isInputCorect = NO;
   }
   
   return isInputCorect;
}

@end