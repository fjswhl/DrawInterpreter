//
//  TestView.h
//  DrawInterpreter
//
//  Created by Lin on 14/11/27.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LINScanner.h"
@class Content;
@interface ExprNode : NSObject

@property  (assign, nonatomic) TokenType tokenType;
@property  (strong, nonatomic) Content *content;

@end

@interface Content : NSObject

@property (strong, nonatomic) ExprNode *left;
@property (strong, nonatomic) ExprNode *right;
@property (assign) CGFloat value;
@property (assign) CGFloat *paramT;
//@property (strong, nonatomic) NSString *func;
@property (assign) double (*fptr)(double);

- (instancetype)initWithLeft:(ExprNode *)left right:(ExprNode *)right;
- (instancetype)initWithValue:(CGFloat)value;
- (instancetype)initWithParamT:(CGFloat *)paramT;

@end

@interface TestView : UIView

- (instancetype)initWithFileName:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

- (void)parser;
- (void)execProgram:(NSString *)code;
//- (void)draw;
@end
