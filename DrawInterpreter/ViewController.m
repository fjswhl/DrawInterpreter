//
//  ViewController.m
//  DrawInterpreter
//
//  Created by Lin on 14/11/27.
//  Copyright (c) 2014年 Lin. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
#import "LINParser.h"
@interface ViewController ()<LINParserDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet TestView *testView;

@property (strong, nonatomic) LINParser *parser;

@property (strong, nonatomic) NSMutableArray *layers;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _parser = [[LINParser alloc] initWithString:nil];
    _parser.delegate = self;
    
    self.layers = [NSMutableArray array];
    
    // Do any additional setup after loading the view, typically from a nib.
//    TestView *v = [[TestView alloc] initWithString:@"ROT IS 0;  ORIGIN IS (100,500); SCALE IS (2, 1); FOR T FROM 0 TO 300 STEP 1 DRAW(T, 0); FOR T FROM 0 TO 300 STEP 1 DRAW(0, -T); FOR T FROM 0 TO 300 STEP 1 DRAW (T, -T); SCALE IS (2,0.1); FOR T FROM 0 TO 55 STEP 1 DRAW (T, -(T*T)); SCALE IS (10,5); FOR T FROM 0 TO 60 STEP 1 DRAW (T, -SQRT(T)); SCALE IS (20, 0.1); FOR T FROM 0 TO 8 STEP 0.1 DRAW (T, -EXP(T)); SCALE IS (2, 20); FOR T FROM 0 TO 300 STEP 1 DRAW (T, -LN(T));"];
    
//    TestView *v = [[TestView alloc] initWithString:@"ORIGIN IS (20,200); ROT IS 0; SCALE IS (40,40); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (20, 240); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (20, 280); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T));"];
    
//    TestView *v = [[TestView alloc] initWithString:@"ORIGIN IS (580, 240); SCALE IS (80,80); ROT IS 0; FOR T FROM 0 TO 2*PI STEP PI/50 DRAW(COS(T),SIN(T)); FOR T FROM 0 TO PI*20 STEP PI/50 DRAW ((1-1/(10/7))*COS(T)+1/(10/7)*COS(-T*((10/7)-1)), (1-1/(10/7))*SIN(T)+1/(10/7)*SIN(-T*((10/7)-1)));"];
////        TestView *v = [[TestView alloc] initWithString:@"FOR T FROM 0 TO 60 STEP 1 DRAW (T, -SQRT(T));"];
//    v.frame = self.view.frame;
//    v.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:v];
//    [v parser];
    self.testView.clipsToBounds = NO;

    self.textView.text = @"ORIGIN IS (680, 240);\nSCALE IS (80,80);\nROT IS 0;\nFOR T FROM 0 TO 2*PI STEP PI/50 DRAW(COS(T),SIN(T));\nFOR T FROM 0 TO PI*20 STEP PI/50 DRAW ((1-1/(10/7))*COS(T)+1/(10/7)*COS(-T*((10/7)-1)), (1-1/(10/7))*SIN(T)+1/(10/7)*SIN(-T*((10/7)-1)));\n ORIGIN IS (100, 240);\nSCALE IS (80, 80/3);\nROT IS PI/2+0*PI/3;\nFOR T FROM -PI TO PI STEP PI/50 DRAW(COS(T), SIN(T));\nROT IS PI/2+2*PI/3;\nFOR T FROM -PI TO PI STEP PI/50 DRAW(COS(T), SIN(T));\nROT IS PI/2-2*PI/3;\nFOR T FROM -PI TO PI STEP PI/50 DRAW(COS(T), SIN(T));\nORIGIN IS (250,200); ROT IS 0; SCALE IS (40,40); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (250, 240); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T)); ORIGIN IS (250, 280); FOR T FROM 0 TO 2*PI + PI/50 STEP PI/50 DRAW(T, SIN(T));\n";
//    self.textView.text = @"ROT IS 0;  ORIGIN IS (100,300); SCALE IS (2, 1); FOR T FROM 0 TO 300 STEP 1 DRAW(T, 0); FOR T FROM 0 TO 300 STEP 1 DRAW(0, -T); FOR T FROM 0 TO 300 STEP 1 DRAW (T, -T); SCALE IS (2,0.1); FOR T FROM 0 TO 55 STEP 1 DRAW (T, -(T*T)); SCALE IS (10,5); FOR T FROM 0 TO 60 STEP 1 DRAW (T, -SQRT(T)); SCALE IS (20, 0.1); FOR T FROM 0 TO 8 STEP 0.1 DRAW (T, -EXP(T)); SCALE IS (2, 20); FOR T FROM 1 TO 300 STEP 1 DRAW (T, -LN(T));";
    

}
- (IBAction)exec:(id)sender {
   // [self.testView execProgram:self.textView.text];
    [_parser execProgram:self.textView.text];
}

- (IBAction)clear:(id)sender {
    for (CAShapeLayer *layer in _layers) {
        [layer removeFromSuperlayer];
        //[_layers removeObject:layer];
    }
    _layers = [NSMutableArray array];
}
//- (void)parserDidFinishParseFORStmtWithData:(ForStmtData)data {
//    UIGraphicsBeginImageContext(self.testView.frame.size);
//    [[UIColor redColor] set];
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//   // CGContextMoveToPoint(ctx, data.origin.x, data.origin.y);
//    for (NSValue *value in data.points) {
//        CGPoint point = [value CGPointValue];
//        CGContextFillRect(ctx, CGRectMake(point.x - 1, point.y - 1, 2, 2));
//    }
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
//    imgView.clipsToBounds = NO;
//    if (data.rotAngel != 0) {
//        imgView.layer.anchorPoint = CGPointMake(data.origin.x / imgView.frame.size.width, data.origin.y / imgView.frame.size.height);
//        NSLog(@"%lf, %lf", data.origin.x, data.origin.y);
//        NSLog(@"%lf, %lf", imgView.layer.anchorPoint.x, imgView.layer.anchorPoint.y);
//        CGAffineTransform trans = CGAffineTransformMakeTranslation(data.origin.x - self.testView.frame.size.width / 2, data.origin.y - self.testView.frame.size.height / 2);
//        trans = CGAffineTransformRotate(trans, data.rotAngel);
//        imgView.transform = trans;
//    }
//
//    imgView.backgroundColor = [UIColor clearColor];
//    UIGraphicsEndImageContext();
//    
//    [self.testView addSubview:imgView];
//    NSLog(@"%@", imgView);
//}

- (void)parserDidFinishParseFORStmtWithData:(ForStmtData)data{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer new];
    [_layers addObject:shapeLayer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = 1;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    NSValue *start = data.points[0];
    [bezierPath moveToPoint:[start CGPointValue]];
    for (int i = 1; i < [data.points count]; i++){
        CGPoint point = [data.points[i] CGPointValue];
        [bezierPath addLineToPoint:point];
        [bezierPath moveToPoint:point];
    }
    
    shapeLayer.path = bezierPath.CGPath;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = 3.0;
    animation.fromValue = @0.0;
    animation.toValue = @1.0;
    [shapeLayer addAnimation:animation forKey:@"strokeEndAnimation"];
    
    [self.testView.layer addSublayer:shapeLayer];
}

- (void)parserDidFailedWithString:(NSString *)errorString{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end























