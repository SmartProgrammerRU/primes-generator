#import <Foundation/Foundation.h>

@interface PGSeachResult : NSObject <NSCoding>

@property (copy, nonatomic) NSString *limit;
@property (strong, nonatomic) NSArray *generatedNumbers;

- (instancetype)initWithLimit:(NSString *)limit numbers:(NSArray *)numbers;

@end