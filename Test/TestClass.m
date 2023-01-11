//
//  TestClass.m
//  Test
//
//  Created by 林君毅 on 2023/1/11.
//

#import "TestClass.h"

@implementation TestBaseClass

+ (void)load {
    NSLog(@"TestBaseClass load");
}

@end

@implementation TestSubClass

+ (void)load {
    NSLog(@"TestSubClass load");
}

@end

@implementation TestBaseClass(Category)

+ (void)load {
    NSLog(@"TestBaseClass(Category) load");
}

@end
