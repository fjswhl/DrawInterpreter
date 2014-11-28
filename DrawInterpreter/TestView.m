//
//  TestView.m
//  DrawInterpreter
//
//  Created by Lin on 14/11/27.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import "TestView.h"

@implementation ExprNode

@end

@implementation Content

- (instancetype)initWithLeft:(ExprNode *)left right:(ExprNode *)right{
    if (self = [super init]) {
        _left = left;
        _right = right;
    }
    return self;
}

- (instancetype)initWithValue:(CGFloat)value{
    if (self = [super init]) {
        _value = value;
    }
    return self;
}

- (instancetype)initWithParamT:(CGFloat *)paramT{
    if (self = [super init]) {
        _paramT = paramT;
    }
    return self;
}

@end

@interface TestView()
@property (strong, nonatomic) LINScanner *scanner;


@end
@implementation TestView {
    Token _token;
    CGFloat _x, _y, _scaleX, _scaleY, _rotAngle;
    CGFloat _t;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)draw{
//    UIGraphicsBeginImageContext(self.frame.size);
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextMoveToPoint(ctx, 0.0, 0.0);
//    CGFloat t = 0;
//    while (t < 100)
//    {
//        //CGPathAddLineToPoint(path, nil, t, pow(t, 2));
//        //CGContextTranslateCTM(ctx, 2, 1);
//        CGContextFillRect(ctx, CGRectMake(t, pow(t, 2), 1, 1));
//        t += 0.1;
//    }
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    imgView.backgroundColor = [UIColor clearColor];
//    UIGraphicsEndImageContext();
//    
//    [self addSubview:imgView];
//}

//- (void)drawRect:(CGRect)rect{
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    //CGMutablePathRef path = CGPathCreateMutable();
//    //CGPathMoveToPoint(path, nil, 0.0, 0.0);
//    [[UIColor redColor] set];
//    CGFloat t = 0;
//    while (t < 100)
//    {
//        //CGPathAddLineToPoint(path, nil, t, pow(t, 2));
//        CGContextTranslateCTM(ctx, 2, 1);
//        CGContextFillRect(ctx, CGRectMake(t, pow(t, 2), 1, 1));
//        t += 0.1;
//        
//    }
//    //CGPathCloseSubpath(path);
//    //CGContextAddPath(ctx, path);
//    //CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
//    //CGContextStrokePath(ctx);
//    //CGPathRelease(path);
//    
//    
//
//
//}

- (instancetype)initWithFileName:(NSString *)string{
    if (self = [super init]){
        _scanner = [[LINScanner alloc] initWithFilename:string];
        _scaleX = 1;
        _scaleY = 1;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
        _scanner = [[LINScanner alloc] initWithString:string];
        _scaleX = 1;
        _scaleY = 1;
    }
    return self;
}
- (void)parser{
    [self fetchToken];
    [self program];
}

- (void)execProgram:(NSString *)code{
    _scanner = [[LINScanner alloc] initWithString:code];
    _scaleX = 1;
    _scaleY = 1;
    [self parser];
}

- (void)syntaxError:(NSInteger)code{
    if (code == 1){
        @throw [NSError errorWithDomain:@"fetchToken failed"
                                   code:code
                               userInfo:nil];
    } else {
        @throw [NSError errorWithDomain:@"not expected token"
                                   code:code
                               userInfo:nil];
    }
    
}
- (void)fetchToken{
    _token = [_scanner getToken];
    if (_token.type == ERRTOKEN) [self syntaxError:1];
    //NSLog(@"%@", _token.lexeme);
}

- (void)matchToken:(TokenType)aToken{
    if (_token.type != aToken) [self syntaxError:2];
    NSLog(@"%@", _token.lexeme);
    [self fetchToken];
}

#pragma mark - recursive descent program

- (void)program{
    while (_token.type != NONTOKEN){
        [self statement];
        [self matchToken:SEMICO];
    }
}

- (void)statement {
    switch (_token.type){
        case ORIGIN:
            [self originStmt];
            break;
        case SCALE:
            [self scaleStmt];
            break;
        case ROT:
            [self rotStmt];
            break;
        case FOR:
            [self forStmt];
            break;
        default: [self syntaxError:2];
    }
}

- (void)originStmt{
    ExprNode *tmp;
    
    [self matchToken:ORIGIN];
    [self matchToken:IS];
    [self matchToken:L_BRACKET];
    tmp = [self expression];
    _x = [self getExprValue:tmp];
    [self matchToken:COMMA];
    tmp = [self expression];
    _y = [self getExprValue:tmp];
    [self matchToken:R_BRACKET];
}

- (void)scaleStmt{
    ExprNode *tmp;
    
    [self matchToken:SCALE];
    [self matchToken:IS];
    [self matchToken:L_BRACKET];
    tmp = [self expression];
    _scaleX = [self getExprValue:tmp];
    [self matchToken:COMMA];
    tmp = [self expression];
    _scaleY = [self getExprValue:tmp];
    [self matchToken:R_BRACKET];
}

- (void)rotStmt{
    ExprNode *tmp;
    
    [self matchToken:ROT];
    [self matchToken:IS];
    tmp = [self expression];
    _rotAngle = [self getExprValue:tmp];
}

- (void)forStmt{
    CGFloat start, ending, step;
    ExprNode *startPtr, *endingPtr, *stepPtr, *x, *y;
    
    [self matchToken:FOR];
    [self matchToken:T];
    [self matchToken:FROM];
    startPtr = [self expression];
    start = [self getExprValue:startPtr];
    [self matchToken:TO];
    endingPtr = [self expression];
    ending = [self getExprValue:endingPtr];
    [self matchToken:STEP];
    stepPtr = [self expression];
    step = [self getExprValue:stepPtr];
    [self matchToken:DRAW];
    [self matchToken:L_BRACKET];
    x = [self expression];
    [self matchToken:COMMA];
    y = [self expression];
    [self matchToken:R_BRACKET];
    //TODO   绘图
    
    UIGraphicsBeginImageContext(self.frame.size);
    [[UIColor redColor] set];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(ctx, _x, _y);
    _t = start;
    while (_t < ending)
    {
        //CGPathAddLineToPoint(path, nil, t, pow(t, 2));
        //CGContextTranslateCTM(ctx, 2, 1);
        CGFloat xPoint = ([self getExprValue:x] * _scaleX + _x);
        CGFloat yPoint = ([self getExprValue:y] * _scaleY + _y);
        CGContextFillRect(ctx, CGRectMake(xPoint - 1, yPoint -1, 2, 2));

        _t += (step/10.0);

    }
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.backgroundColor = [UIColor clearColor];
    UIGraphicsEndImageContext();
    
    [self addSubview:imgView];
    
    NSLog(@"forDone");
}

- (ExprNode *)expression {
    ExprNode *left, *right;
    TokenType tokenTmp;
    
    left = [self term];
    while (_token.type == PLUS || _token.type == MINUS){
        tokenTmp = _token.type;
        [self matchToken:tokenTmp];
        right = [self term];
        
        Content *content = [[Content alloc] initWithLeft:left right:right];
        left = [self makeExprNode:tokenTmp content:content];
    }
    
    return left;
}

- (ExprNode *)term{
    ExprNode *left, *right;
    TokenType tokenTmp;
    
    left = [self factor];
    while (_token.type == MUL || _token.type == DIV){
        tokenTmp = _token.type;
        [self matchToken:tokenTmp];
        right = [self factor];
        
        Content *content = [[Content alloc] initWithLeft:left right:right];
        left = [self makeExprNode:tokenTmp content:content];
    }
    return left;
}

- (ExprNode *)factor{
    ExprNode *left, *right;
    if (_token.type == PLUS){
        [self matchToken:PLUS];
        right = [self factor];
    } else if (_token.type == MINUS){
        [self matchToken:MINUS];
        right = [self factor];
        left = [ExprNode new];
        left.tokenType = CONST_ID;
        left.content = [[Content alloc] initWithValue:0.0];
        
        Content *content = [[Content alloc] initWithLeft:left right:right];
        right = [self makeExprNode:MINUS content:content];
    } else{
        right = [self component];
    }
    
    return right;
}

- (ExprNode *)component{
    ExprNode *left, *right;
    
    left = [self atom];
    if (_token.type == POWER){
        [self matchToken:POWER];
        right = [self component];
        
        Content *content = [[Content alloc] initWithLeft:left right:right];
        left = [self makeExprNode:POWER content:content];
    }
    return left;
}

- (ExprNode *)atom{
    Token token = _token;
    ExprNode *node, *tmp;
    
    switch (_token.type) {
        case CONST_ID:
            [self matchToken:CONST_ID];
            node = [self makeExprNode:CONST_ID content:[[Content alloc] initWithValue:token.value]];
            break;
        case T:
            [self matchToken:T];
            
            node = [self makeExprNode:T content:[[Content alloc] initWithParamT:&_t]];
            break;
        case FUNC:{

            [self matchToken:FUNC];
            [self matchToken:L_BRACKET];
            

            tmp = [self expression];
            Content *c = [Content new];
            c.right = tmp;
            c.fptr = token.fptr;
            node = [self makeExprNode:FUNC content:c];
            [self matchToken:R_BRACKET];
            break;
        }
        case L_BRACKET:
            [self matchToken:L_BRACKET];
            node = [self expression];
            [self matchToken:R_BRACKET];
            break;
        default:
            [self syntaxError:2];
    }
    return node;
}


- (ExprNode *)makeExprNode:(TokenType)tokenType content:(Content *)content{
    //TODO TEST
    ExprNode *node = [ExprNode new];
    node.tokenType = tokenType;
    node.content = content;
//    switch (tokenType){
//        case CONST_ID:
//            node.content = [@{@"value": dic[@"value"]} mutableCopy];
//            break;
//        case FUNC:
//            node.content = [@{@"value": dic[@"value"]} mutableCopy];
//            break;
//        case T:
//            node.content = [@{@"value": _t} mutableCopy];
//            break;
//        default:
//            node.content = [@{@"left": dic[@"left"],
//                             @"right": dic[@"right"]} mutableCopy];
//            break;
//    }
    return node;
}

- (double)getExprValue:(ExprNode *)root {
    if  (!root) return 0.0;
    switch (root.tokenType) {
        case PLUS:
            return [self getExprValue:root.content.left] + [self getExprValue:root.content.right];
        case MINUS:
            return [self getExprValue:root.content.left] - [self getExprValue:root.content.right];
        case MUL:
            return [self getExprValue:root.content.left] * [self getExprValue:root.content.right];
        case DIV:
            return [self getExprValue:root.content.left] / [self getExprValue:root.content.right];
        case POWER:
            return pow([self getExprValue:root.content.left], [self getExprValue:root.content.right]);
        case FUNC:
            return (*root.content.fptr)([self getExprValue:root.content.right]);
        case CONST_ID:
            return root.content.value;
        case T:                //TODO TEST
            return *root.content.paramT;
        default:
            return 0.0;
            
    }
}



@end
