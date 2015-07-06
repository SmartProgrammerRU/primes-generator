#import "PGSearchHistory.h"

@implementation PGSearchHistory

- (instancetype)init
{
   if (self = [super init]) {
      _largestSearchedNumber = @-1;
      _largestGeneratedNumbersArray = @[];
      _searchedNumbers = @[];
   }
   
   return self;
}


#pragma mark - Logic

- (BOOL)saveToHistory:(NSString *)limit numbers:(NSArray *)generatedNumbers
{
   if (![generatedNumbers isKindOfClass:[NSArray class]] || ![limit isKindOfClass:[NSString class]]) {
      return NO;
   }
   
   NSNumber *largestSearchedNumber = self.largestSearchedNumber;
   NSNumber *enteredNumber = @([limit longLongValue]);
   NSComparisonResult result = [enteredNumber compare:largestSearchedNumber];
   if (result == NSOrderedDescending) {
      self.largestSearchedNumber = enteredNumber;
      self.largestGeneratedNumbersArray = generatedNumbers;
   }
   
   NSArray *searchedNumbers = self.searchedNumbers;
   searchedNumbers = [searchedNumbers arrayByAddingObject:enteredNumber];
   self.searchedNumbers = searchedNumbers;
   
   return YES;
}

- (NSArray *)parseToTableViewReadableData:(NSArray *)largestGeneratedSimplesArray key:(NSNumber *)limit
{
   Number elementToFind = [limit longLongValue];
   Number largestSimple = [[largestGeneratedSimplesArray lastObject] longLongValue];
   NSArray *simples = [NSArray array];
   
   if (elementToFind >=2) {
      while (![self isPrime:elementToFind]) {
         elementToFind--;
      }
      
      if (elementToFind == largestSimple) {
         return largestGeneratedSimplesArray;
      }
      
      Number index = [self searchForIndex:largestGeneratedSimplesArray withNumber:elementToFind];
      simples = [self.largestGeneratedNumbersArray subarrayWithRange:NSMakeRange(0, (UInt32)index+1)];
   }
   
   return simples;
}

- (BOOL)isPrime:(Number)number
{
   if (number <= 1) {
      return NO;
   }
   Number i;
   for (i=2; i*i<=number; i++) {
      if (number % i == 0)
         return 0;
   }
   
   return YES;
}

- (Number)searchForIndex:(NSArray *)numbers withNumber:(Number)key
{
   Number imin = 0;
   Number imax = [numbers count] - 1;
   
   while (imax >= imin) {
      Number imid = imin + ((imax - imin) / 2);
      Number value = [numbers[(UInt32)imid] longLongValue];
      if(value == key) {
         // key found at index imid
         return imid;
         // determine which subarray to search
      } else if (value < key) {
         // change min index to search upper subarray
         imin = imid + 1;
      } else {
         // change max index to search lower subarray
         imax = imid - 1;
      }
   }
   
   // key was not found
   return -1;
}


#pragma mark - NSCoding Protocol

- (void)encodeWithCoder:(NSCoder *)aCoder
{
   [aCoder encodeObject:_largestSearchedNumber forKey:kNumber];
   [aCoder encodeObject:_largestGeneratedNumbersArray forKey:kNumbersArray];
   [aCoder encodeObject:_searchedNumbers forKey:kSearchedNumbers];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
   if (self = [super init]) {
      _largestSearchedNumber = [aDecoder decodeObjectForKey:kNumber];
      _largestGeneratedNumbersArray = [aDecoder decodeObjectForKey:kNumbersArray];
      _searchedNumbers = [aDecoder decodeObjectForKey:kSearchedNumbers];
   }
   
   return self;
}

@end