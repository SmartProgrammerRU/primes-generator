#import <Foundation/Foundation.h>

typedef __uint64_t Number; // __uint32_t
static Number lastNumber = 1*1000*1000*1000LL;
static NSString *const kNumber = @"largestSearchedNumber";
static NSString *const kNumbersArray = @"largestGeneratedNumbersArray";
static NSString *const kSearchedNumbers = @"searchedNumbers";

@interface PGSearchHistory : NSObject <NSCoding>

@property (strong, nonatomic) NSNumber *largestSearchedNumber;
@property (strong, nonatomic) NSArray *largestGeneratedNumbersArray;
@property (strong, nonatomic) NSArray *searchedNumbers;

- (BOOL)saveToHistory:(NSString *)limit numbers:(NSArray *)generatedNumbers;
- (NSArray *)parseToTableViewReadableData:(NSArray *)largestGeneratedSimplesArray key:(NSNumber *)limit;

@end