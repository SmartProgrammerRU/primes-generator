#import "PGHistoryViewController.h"
#import "PGResultCell.h"

@implementation PGHistoryViewController

#pragma mark - Lifecyle

- (void)viewDidLoad {
   [super viewDidLoad];
   self.navigationController.navigationBarHidden = NO;
//   [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
   self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
}


#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [self.cachedResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   static NSString *const cellIdentifier = @"Cell";;
   PGResultCell *cell = (PGResultCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier
                                                                        forIndexPath:indexPath];
   if (!cell) {
      cell = [[PGResultCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
   }
   
   NSString *showResultsString = [self cellTitleText:indexPath];
   cell.textView.text = showResultsString;
   [cell.textView scrollRangeToVisible:NSMakeRange(0, 1)];
   
   return cell;
}

- (NSString *)cellTitleText:(NSIndexPath *)indexPath
{
   PGSeachResult *result = self.cachedResults[indexPath.row];
   NSString *generatedNumbers = [result.generatedNumbers componentsJoinedByString:@", "];
   
   /* ex.: [NSString stringWithFormat:@"%@", @"Пользователь вводит: 10 Список чисел: [2,3,5,7]"]; */
   NSString *showResultsString =
   [NSString stringWithFormat:@"Пользователь вводит: %@\nСписок чисел: [ %@ ]",
    result.limit, generatedNumbers];
   
   return showResultsString;
}

@end