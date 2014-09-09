//
// TaskSequenceTests.m
// TaskSequenceTests
//
// Copyright (c) 2014 Hironori Ichimiya <hiron@hironytic.com>
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to
// permit persons to whom the Software is furnished to do so, subject to
// the following conditions:
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
// CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
// TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import <XCTest/XCTest.h>
#import "TSContext.h"
#import "TSSequence.h"

@interface TaskSequenceTests : XCTestCase

@end

@implementation TaskSequenceTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRunTask {
    __block int value = 1;
    TSContext *context = [[TSContext alloc] init];
    TSSequence *sequence = [TSSequence sequenceWithBlocks:@[^id(TSContext *context) {
        XCTAssertNil(context.result);
        value = value * 10 + 2;
        return @"Wow";
    }, ^id(TSContext *context) {
        XCTAssertEqualObjects(context.result, @"Wow");
        value = value * 10 + 3;
        return @33;
    }, ^id(TSContext *context) {
        value = value * 10 + 4;
        XCTAssertEqualObjects(context.result, @33);
        return nil;
    }]];

    [TSSequence runSequence:sequence context:context];
    XCTAssertEqual(value, 1234);
}

- (void)testRunTaskWithSubtask {
    __block int value = 1;
    TSContext *context = [[TSContext alloc] init];
    TSSequence *sequence = [TSSequence sequenceWithBlocks:@[^id(TSContext *context) {
        XCTAssertNil(context.result);
        value = value * 10 + 2;
        return [TSSequence sequenceWithBlock:^id(TSContext *context) {
            XCTAssertNil(context.result);
            value = value * 10 + 5;
            return @8;
        }];
    }, ^id(TSContext *context) {
        XCTAssertEqualObjects(context.result, @8);
        value = value * 10 + 3;
        return @33;
    }, ^id(TSContext *context) {
        value = value * 10 + 4;
        XCTAssertEqualObjects(context.result, @33);
        return nil;
    }]];
    
    [TSSequence runSequence:sequence context:context];
    XCTAssertEqual(value, 12534);
}

@end
