//
//  LINParser.m
//  DrawInterpreter
//
//  Created by Lin on 14/12/2.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import "LINParser.h"

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
@interface LINParser()
@property (strong, nonatomic) LINScanner *scanner;


@end
@implementation LINParser{
        Token _token;
        ForStmtData _data;
        CGFloat _t;
}

- (instancetype)initWithFileName:(NSString *)string{
    if (self = [super init]){
        _scanner = [[LINScanner alloc] initWithFilename:string];
        _data.scale.dx = 1;
        _data.scale.dy = 1;
    }
    return self;
}

- (instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
        _scanner = [[LINScanner alloc] initWithString:string];
        _data.scale.dx = 1;
        _data.scale.dy = 1;
    }
    return self;
}
- (void)parser{
    [self fetchToken];
    [self program];
}

- (void)execProgram:(NSString *)code{
    _scanner = [[LINScanner alloc] initWithString:code];
    _data.scale.dx = 1;
    _data.scale.dy = 1;
    [self parser];
}

- (void)syntaxError:(NSInteger)code{
    if (code == 1){
        [self.delegate parserDidFailedWithString:@"fetchToken failed"];
//        @throw [NSError errorWithDomain:@"fetchToken failed"
//                                   code:code
//                               userInfo:nil];
    } else {
        [self.delegate parserDidFailedWithString:@"not expected token"];
//        @throw [NSError errorWithDomain:@"not expected token"
//                                   code:code
//                               userInfo:nil];
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
    _data.origin.x = [self getExprValue:tmp];
    [self matchToken:COMMA];
    tmp = [self expression];
    _data.origin.y = [self getExprValue:tmp];
    [self matchToken:R_BRACKET];
}

- (void)scaleStmt{
    ExprNode *tmp;
    
    [self matchToken:SCALE];
    [self matchToken:IS];
    [self matchToken:L_BRACKET];
    tmp = [self expression];
    _data.scale.dx = [self getExprValue:tmp];
    [self matchToken:COMMA];
    tmp = [self expression];
    _data.scale.dy = [self getExprValue:tmp];
    [self matchToken:R_BRACKET];
}

- (void)rotStmt{
    ExprNode *tmp;
    
    [self matchToken:ROT];
    [self matchToken:IS];
    tmp = [self expression];
    _data.rotAngel = [self getExprValue:tmp];
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
    //TODO   绘图  done
    
    _t = start;
    NSMutableArray *points = [NSMutableArray array];
    while (_t < ending)
    {
        CGFloat xPoint = [self getExprValue:x] * _data.scale.dx;
        CGFloat yPoint = [self getExprValue:y] * _data.scale.dy;
        CGFloat tx = xPoint;
        CGFloat ty = yPoint;
        xPoint = tx * cos(_data.rotAngel) + ty * sin(_data.rotAngel);
        yPoint = ty * cos(_data.rotAngel) - tx * sin(_data.rotAngel);
        
         xPoint = (xPoint + _data.origin.x);
         yPoint = (yPoint + _data.origin.y);

        [points addObject:[NSValue valueWithCGPoint:CGPointMake(xPoint, yPoint)]];
        _t += (step);
        
    }
    _data.points = points;
    [self.delegate parserDidFinishParseFORStmtWithData:_data];
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

























