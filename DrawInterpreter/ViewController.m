//
//  ViewController.m
//  DrawInterpreter
//
//  Created by Lin on 14/11/27.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet TestView *testView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    TestView *v = [[TestView alloc] initWithString:@"ROT IS 0;  ORIGIN IS (100,500); SCALE IS (2, 1); FOR T FROM 0 TO 300 STEP 1 DRAW(T, 0); FOR T FROM 0 TO 300 STEP 1 DRAW(0, -T); FOR T FROM 0 TO 300 STEP 1 DRAW (T, -T); SCALE IS (2,0.1); FOR T FROM 0 TO 55 STEP 1 DRAW (T, -(T*T)); SCALE IS (10,5); FOR T FROM 0 TO 60 STEP 1 DRAW (T, -SQRT(T)); SCALE IS (20, 0.1); FOR T FROM 0 TO 8 STEP 0.1 DRAW (T, -EXP(T)); SCALE IS (2, 20); FOR T FROM 0 TO 300 STEP 1 DRAW (T, -LN(T));"];
    
//    TestView *v = [[TestView alloc] initWithString:@"ORIGIN IS (20,200); ROT IS 0; SCALE IS (40,40); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (20, 240); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (20, 280); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T));"];
    
//    TestView *v = [[TestView alloc] initWithString:@"ORIGIN IS (580, 240); SCALE IS (80,80); ROT IS 0; FOR T FROM 0 TO 2*PI STEP PI/50 DRAW(COS(T),SIN(T)); FOR T FROM 0 TO PI*20 STEP PI/50 DRAW ((1-1/(10/7))*COS(T)+1/(10/7)*COS(-T*((10/7)-1)), (1-1/(10/7))*SIN(T)+1/(10/7)*SIN(-T*((10/7)-1)));"];
////        TestView *v = [[TestView alloc] initWithString:@"FOR T FROM 0 TO 60 STEP 1 DRAW (T, -SQRT(T));"];
//    v.frame = self.view.frame;
//    v.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:v];
//    [v parser];

    self.textView.text = @"ORIGIN IS (580, 240);\nSCALE IS (80,80);\nROT IS 0;\nFOR T FROM 0 TO 2*PI STEP PI/50 DRAW(COS(T),SIN(T));\nFOR T FROM 0 TO PI*20 STEP PI/50 DRAW ((1-1/(10/7))*COS(T)+1/(10/7)*COS(-T*((10/7)-1)), (1-1/(10/7))*SIN(T)+1/(10/7)*SIN(-T*((10/7)-1)));\n";

}
- (IBAction)exec:(id)sender {
    [self.testView execProgram:self.textView.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
