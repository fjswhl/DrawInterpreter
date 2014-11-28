//
//  LINScanner.m
//  LexemeAnalysis-OC
//
//  Created by Lin on 14/11/7.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import "LINScanner.h"

Token TokenTab[] = {
    {CONST_ID,  @"PI",       3.1415926,  NULL},
    {CONST_ID,  @"E",        2.71828,    NULL},
    {T,         @"T",        0.0,        NULL},
    {FUNC,      @"SIN",      0.0,        sin},
    {FUNC,      @"COS",      0.0,        cos},
    {FUNC,      @"TAN",      0.0,        tan},
    {FUNC,      @"LN",       0.0,        log},
    {FUNC,      @"EXP",      0.0,        exp},
    {FUNC,      @"SQRT",     0.0,        sqrt},
    {ORIGIN,    @"ORIGIN",   0.0,        NULL},
    {SCALE,     @"SCALE",    0.0,        NULL},
    {ROT,       @"ROT",      0.0,        NULL},
    {IS,        @"IS",       0.0,        NULL},
    {FOR,       @"FOR",      0.0,        NULL},
    {FROM,      @"FROM",     0.0,        NULL},
    {TO,        @"TO",       0.0,        NULL},
    {STEP,      @"STEP",     0.0,        NULL},
    {DRAW,      @"DRAW",     0.0,        NULL}
};

@implementation LINScanner{
    NSString *_tokenBuffer;
    
    // for storing inputed file's contents
    NSString *_fileContents;
    
    // range for a token buffer
    NSUInteger _offsetEnd;
    NSUInteger _offsetBegin;
    
    NSUInteger _fileLength;
    NSUInteger _lineNo;
}


//+ (instancetype)sharedScanner{
//    static LINScanner *sharedScanner = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        sharedScanner = [[LINScanner alloc] init];
//    });
//    return sharedScanner;
//}


- (instancetype)initWithFilename:(NSString *)fileName{
    if (self = [super init]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:fileName]) {
            _fileContents = [NSString stringWithContentsOfFile:fileName encoding:NSUTF8StringEncoding error:nil];
            _lineNo = 1;
            _fileLength = [_fileContents length];
        }
       // NSLog(@"%@", _fileContents);
        if (_fileContents != nil) {
            return self;
        }
    }
    return nil;
}

- (instancetype)initWithString:(NSString *)string{
    if (self = [super init]) {
            _fileContents = string;
            _lineNo = 1;
            _fileLength = [_fileContents length];
        // NSLog(@"%@", _fileContents);
        if (_fileContents != nil) {
            return self;
        }
    }
    return nil;
}


- (Token)getToken{
    Token token;
    unichar character;
    memset(&token, 0, sizeof(token));

    _offsetBegin = _offsetEnd;
    while (1) {
        character = [self getChar];
        if (character == 0) {
            token.type = NONTOKEN;
            return token;
        }
        if (character == '\n') {
            _lineNo++;
        }
        if (!isspace(character)) {
            break;
        }
    }
    _offsetBegin = _offsetEnd - 1;
    
    // if it is alpha, it must be id,constant,reserved word
    if (isalpha(character)) {
        while (1) {
            character = [self getChar];
            if (!isalnum(character)) {
                break;
            }
        }
        [self backChar];
        token = [self judgeKeyToken:_tokenBuffer];
        token.lexeme = _tokenBuffer;                    //TODO TEST
        return token;
    }else if (isdigit(character)){              //number
        while (1) {
            character = [self getChar];
            if (!isdigit(character)) {
                break;
            }
        }
        if (character == '.') {
            while (1) {
                character = [self getChar];
                if (!isdigit(character)) {
                    break;
                }
            }
        }
        
        [self backChar];
        token.type = CONST_ID;
        token.lexeme = _tokenBuffer;
        token.value = [_tokenBuffer doubleValue];
        return token;
    }else{
        switch (character) {
            case ';':
                token.type = SEMICO; break;
            case '(':
                token.type = L_BRACKET; break;
            case ')':
                token.type = R_BRACKET; break;
            case ',':
                token.type = COMMA; break;
            case '+':
                token.type = PLUS; break;
            case '-':{
                character = [self getChar];
                if (character == '-') {
                    while (character != '\n' && character != 0) {
                        character = [self getChar];
                    }
                    [self backChar];
                    return [self getToken];
                }else{
                    [self backChar];
                    token.type = MINUS;
                    break;
                }
            }
            case '/':{
                character = [self getChar];
                if (character == '/') {
                    while (character != '\n' && character != 0) {
                        character = [self getChar];
                    }
                    [self backChar];
                    return [self getToken];
                }else{
                    [self backChar];
                    token.type = DIV;
                    break;
                }
            }
            case '*':{
                character = [self getChar];
                if (character == '*') {
                    token.type = POWER;
                    break;
                }else{
                    [self backChar];
                    token.type = MUL;
                    break;
                }
            }
            default: token.type = ERRTOKEN;
                break;
        }
    }
    [self calTokenBuffer];
    token.lexeme = _tokenBuffer;
    return token;
}

#pragma mark -- helper method

/**
 *  后退字符指针，并计算tokenbuffer
 */
- (void)backChar{
    _offsetEnd--;
    [self calTokenBuffer];
}

- (void)calTokenBuffer{
    _tokenBuffer = [_fileContents substringWithRange:NSMakeRange(_offsetBegin, _offsetEnd-_offsetBegin)];
}

- (unichar)getChar{
    if (_offsetEnd != _fileLength) {
        return toupper([_fileContents characterAtIndex:_offsetEnd++]);   //TODO TEST
    }
    return 0;
}

- (Token)judgeKeyToken:(NSString *)IDString{
    for (int i = 0; i < sizeof(TokenTab) / sizeof(TokenTab[0]); i++) {
        if ([TokenTab[i].lexeme isEqualToString: IDString]) {
            return TokenTab[i];
        }
    }
    
    Token errorToken;
    memset(&errorToken, 0, sizeof(Token));
    errorToken.type = ERRTOKEN;
    return errorToken;
}

@end












































