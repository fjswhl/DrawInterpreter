//
//  LINScanner.h
//  LexemeAnalysis-OC
//
//  Created by Lin on 14/11/7.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TokenType) {
    ORIGIN,SCALE, ROT, IS, TO,
    STEP, DRAW, FOR, FROM,
    T,
    SEMICO, L_BRACKET, R_BRACKET, COMMA,
    PLUS, MINUS, MUL, DIV, POWER,
    FUNC,
    CONST_ID,
    NONTOKEN,
    ERRTOKEN
};


typedef double(*MathFuncPtr)(double);

typedef struct{
    TokenType type;
    __unsafe_unretained NSString *lexeme;
    double value;
    double (*fptr)(double);
}Token;





@interface LINScanner : NSObject

- (instancetype)initWithFilename:(NSString *)fileName;
- (instancetype)initWithString:(NSString *)string;

//+ (instancetype)sharedScanner;
- (Token)getToken;
//  tokentabs for storing reserved word and constant values like PI,E etc.
//@property (strong, nonatomic) NSArray *tokenTable;


@end


