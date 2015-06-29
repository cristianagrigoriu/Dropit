
//
//  ViewController.m
//  Dropit
//
//  Created by Cristiana on 25/06/15.
//  Copyright (c) 2015 Cristiana. All rights reserved.
//

#import "ViewController.h"
#import "DropitBehaviour.h"
#import "BezierPathView.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet BezierPathView *GameView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) DropitBehaviour *dropitBehaviour;
@property (strong, nonatomic) UIAttachmentBehavior *attachment;
@property (strong, nonatomic) UIView *droppingView;

@end

@implementation ViewController

static const CGSize DROP_SIZE = {42, 42};

- (UIDynamicAnimator *) animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.GameView];
        _animator.delegate = self;
        
    }
    return _animator;
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeCompletedRow];
}

- (BOOL) removeCompletedRow
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    
    for (CGFloat y = self.GameView.bounds.size.height-DROP_SIZE.height/2; y > 0; y -= DROP_SIZE.height) {
        BOOL rowIsComplete = YES;
        NSMutableArray *dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2; x <= self.GameView.bounds.size.width-DROP_SIZE.width/2; x += DROP_SIZE.width) {
            UIView *hitView = [self.GameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([hitView superview] == self.GameView) {
                [dropsFound addObject:hitView];
            }
            else {
                rowIsComplete = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (rowIsComplete) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    
    if ([dropsToRemove count]) {
        for (UIView *drop in dropsToRemove) {
            [self.dropitBehaviour removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void)animateRemovingDrops:(NSArray *)dropsToRemove
{
    [UIView animateWithDuration:1.0
                     animations:^{ //they blow up somewhere off screen
                         for (UIView *drop in dropsToRemove) {
                             int x = (arc4random()%(int)self.GameView.bounds.size.width*5 - (int)self.GameView.bounds.size.width*2);
                             int y = self.GameView.bounds.size.height;
                             drop.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished) { //every item from the last row gets removed from the screen
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

- (DropitBehaviour *)dropitBehaviour
{
    if (!_dropitBehaviour) {
        _dropitBehaviour = [[DropitBehaviour alloc] init];
        [self.animator addBehavior:_dropitBehaviour];
    }
    return _dropitBehaviour;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    //where did the pan happen
    CGPoint gesturePoint = [sender locationInView:self.GameView];
    if (sender.state == UIGestureRecognizerStateBegan) { //could use snippet for all if clauses
        [self attachDroppingViewToPoint:gesturePoint];
        
    } else if (sender.state == UIGestureRecognizerStateChanged) { //attach between an item and an anchor point (that follows my finger)
        self.attachment.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachment];
        self.GameView.path = nil;
    }
}

- (void) attachDroppingViewToPoint:(CGPoint)anchorPoint
{
    if (self.droppingView) {
        self.attachment = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView *droppingView = self.droppingView; //because the action block gets executed every time and it sets self.droppingView to nil, so we need a local variable to store it
        __weak ViewController *weakSelf = self; //we use this because otherwise we would have a strong pointer to ourselves in the block, because it also contains a strong pointer to self (in self.attachment.anchorPoint, for example), which is now replaced with a weak pointer (weakSelf)
        self.attachment.action = ^{
            UIBezierPath *path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachment.anchorPoint];//the anchor point's current attachment point
            [path addLineToPoint:droppingView.center];
            weakSelf.GameView.path = path;
        };
        //self.droppingView = nil; //done in order not to be able to grab that thing and drop it and grab it again
        [self.animator addBehavior:self.attachment];
    }
}

- (void)drop
{
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = (arc4random()%(int)self.GameView.bounds.size.width) / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView *dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColor];
    [self.GameView addSubview:dropView];
    
    self.droppingView = dropView;
    
    [self.dropitBehaviour addItem:dropView];
}

- (UIColor *)randomColor
{
    switch (arc4random()%5) {
        case 0: return [UIColor greenColor];
        case 1: return [UIColor blueColor];
        case 2: return [UIColor orangeColor];
        case 3: return [UIColor redColor];
        case 4: return [UIColor purpleColor];
    }
    return [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
