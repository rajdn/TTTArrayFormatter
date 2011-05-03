// TTTArrayFormatter.m
//
// Copyright (c) 2011 Mattt Thompson (http://mattt.me)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TTTArrayFormatter.h"

@interface TTTArrayFormatter ()
@property (nonatomic, assign) TTTArrayFormatterStyle arrayStyle;
@property (nonatomic, copy) NSString *delimiter;
@property (nonatomic, copy) NSString *conjunction;
@property (nonatomic, copy) NSString *abbreviatedConjunction;
@property (nonatomic, assign) BOOL usesAbbreviatedConjunction;
@property (nonatomic, assign) BOOL usesSerialDelimiter;
@end

@implementation TTTArrayFormatter
@synthesize arrayStyle;
@synthesize delimiter;
@synthesize conjunction;
@synthesize abbreviatedConjunction;
@synthesize usesAbbreviatedConjunction;
@synthesize usesSerialDelimiter;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.delimiter = NSLocalizedString(@", ", @"List delimiter");
    self.conjunction = NSLocalizedString(@"and ", @"List conjunction");
    self.abbreviatedConjunction = NSLocalizedString(@" & ", nil);
    self.usesAbbreviatedConjunction = NO;
    self.usesSerialDelimiter = YES;
    
    return self;
}

- (void)dealloc {
    [delimiter release];
    [conjunction release];
    [abbreviatedConjunction release];
    [super dealloc];
}

- (NSString *)stringFromArray:(NSArray *)anArray {
    return [self stringForObjectValue:anArray];
}

- (NSArray *)arrayFromString:(NSString *)aString {
    NSArray *array = nil;
    [self getObjectValue:&array forString:aString errorDescription:nil];
    
    return array;
}

+ (NSString *)localizedStringFromArray:(NSArray *)anArray arrayStyle:(TTTArrayFormatterStyle)style {
    TTTArrayFormatter *formatter = [[[TTTArrayFormatter alloc] init] autorelease];
    [formatter setArrayStyle:style];
    
    return [formatter stringFromArray:anArray];
}

#pragma mark NSFormatter

- (NSString *)stringForObjectValue:(id)anObject {
    if (![anObject isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableString *mutableOutput = [NSMutableString stringWithString:@""];
    NSArray *components = (NSArray *)anObject;
    for (NSUInteger idx = 0; idx < [components count]; idx++) {
        NSString *component = [[components objectAtIndex:idx] description];

        if (idx != 0) {
            if (self.conjunction && self.usesSerialDelimiter) {
                [mutableOutput appendString:self.delimiter];
            }
            
            if (self.conjunction && self.arrayStyle != TTTArrayFormatterDataStyle && idx == [components count] - 1) {
                [mutableOutput appendString:self.conjunction];
            }
        }
        
        if (component) {
             [mutableOutput appendString:component];
        }       
    }
    
    return [NSString stringWithString:mutableOutput];
}

- (BOOL)getObjectValue:(id *)obj forString:(NSString *)string errorDescription:(NSString **)error {
    BOOL returnValue = NO;
    NSMutableArray *components = nil;
    
    if (string) {
        components = [[string componentsSeparatedByString:self.delimiter] mutableCopy];
        NSMutableString *lastComponent = [(NSString *)[components lastObject] mutableCopy];
        NSRange lastComponentConjunctionRange = [lastComponent rangeOfString:self.conjunction];
        if (lastComponentConjunctionRange.location != NSNotFound) {
            [lastComponent replaceCharactersInRange:lastComponentConjunctionRange withString:self.delimiter];
            [components removeLastObject];
            [components addObjectsFromArray:[lastComponent componentsSeparatedByString:self.delimiter]];
        }
        
        if (components) {
            *obj = [NSArray arrayWithArray:components];
        } else {
            if (error) {
                *error = NSLocalizedString(@"Couldn’t convert to NSArray", @"Error converting to NSArray");   
            }
        }
    }
    
    return returnValue;
}

@end
