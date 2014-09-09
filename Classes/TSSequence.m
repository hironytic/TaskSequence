//
// TSSequence.h
// TaskSequence
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

#import "TSSequence.h"
#import "TSContext.h"

@interface TSSequence ()
@property(nonatomic, strong) NSArray *blocks;
@end

@implementation TSSequence

+ (instancetype)sequenceWithBlock:(TSTaskBlock)block {
    return [[TSSequence alloc] initWithBlocks:@[block]];
}
+ (instancetype)sequenceWithBlocks:(NSArray *)blocks {
    return [[TSSequence alloc] initWithBlocks:blocks];
}

- (instancetype)initWithBlocks:(NSArray *)blocks {
    self = [super init];
    if (self != nil) {
        _blocks = blocks;
    }
    return self;
}

+ (void)runSequence:(TSSequence *)sequence context:(TSContext *)context {
    if (sequence == nil) {
        return;
    }
    
    NSMutableArray *taskStack = [[NSMutableArray alloc] initWithCapacity:[sequence.blocks count]];
    for (TSTaskBlock aBlock in [sequence.blocks reverseObjectEnumerator]) {
        [taskStack addObject:aBlock];
    }
    
    while ([taskStack count] > 0) {
        TSTaskBlock block = [taskStack lastObject];
        [taskStack removeLastObject];
        
        id result = block(context);
        if (result != nil && [result isKindOfClass:[TSSequence class]]) {
            TSSequence *preceding = result;
            if (preceding != nil) {
                for (TSTaskBlock aBlock in [preceding.blocks reverseObjectEnumerator]) {
                    [taskStack addObject:aBlock];
                }
            }
        } else {
            context.result = result;
        }
    }
}

@end
