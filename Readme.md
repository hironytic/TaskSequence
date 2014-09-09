Task Sequence
=============

## About

TODO:

## Example

### Tower of Hanoi

#### Recursive Version

```objc
- (void)hanoiWithCount:(NSInteger)count
             fromTower:(NSString *)from
               toTower:(NSString *)to
            otherTower:(NSString *)other {
    if (count <= 0) {
        return;
    }
    
    [self hanoiWithCount:count - 1
               fromTower:from
                 toTower:other
              otherTower:to];
    
    NSLog(@"move disk #%ld from %@ to %@", (long)count, from, to);
    
    [self hanoiWithCount:count - 1
               fromTower:other
                 toTower:to
              otherTower:from];
}

- (void)doHanoi {
    [self hanoiWithCount:3
               fromTower:@"A"
                 toTower:@"B"
              otherTower:@"C"];
}

```

#### (Actually) Non-recursive Version

```objc
- (TSSequence *)hanoiWithCount:(NSInteger)count
                     fromTower:(NSString *)from
                       toTower:(NSString *)to
                    otherTower:(NSString *)other {
    if (count <= 0) {
        return nil;
    }
    
    return [TSSequence sequenceWithBlocks:@[^id(TSContext *context) {
        return [self hanoiWithCount:count - 1
                          fromTower:from
                            toTower:other
                         otherTower:to];
        
    },^id(TSContext *context) {
        NSLog(@"move disk #%ld from %@ to %@", (long)count, from, to);
        return nil;
        
    },^id(TSContext *context) {
        return [self hanoiWithCount:count - 1
                          fromTower:other
                            toTower:to
                         otherTower:from];
    }]];
}

- (void)doHanoi {
    TSSequence *sequence = [self hanoiWithCount:3
                                      fromTower:@"A"
                                        toTower:@"B"
                                     otherTower:@"C"];

    TSContext *context = [[TSContext alloc] init];
    [TSSequence runSequence:sequence context:context];
}
```

## Install

TODO:


## License

The MIT License.
