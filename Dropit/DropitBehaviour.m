//
//  DropitBehaviour.m
//  Dropit
//
//  Created by Cristiana on 25/06/15.
//  Copyright (c) 2015 Cristiana. All rights reserved.
//

#import "DropitBehaviour.h"

@interface DropitBehaviour()
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *animationOptions;
@end

@implementation DropitBehaviour

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 1.0;
    }
    return _gravity;
}

- (UICollisionBehavior *)collider
{
    if (!_collider) {
        _collider  = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES; //have screen bounds, don't go off screen
    }
    return _collider;
}

-(UIDynamicItemBehavior *)animationOptions
{
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc] init];
        _animationOptions.allowsRotation = NO; //objects can't rotate
    }
    
    return _animationOptions;
}

- (instancetype)init
{
    self = [super init];
    
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    [self addChildBehavior:self.animationOptions];
    
    return self;
}

- (void)   addItem:(id <UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collider addItem:item]; //by default, if you click the button fast, they start falling not on top of each other, but they also tilt to the sides

    [self.animationOptions addItem:item];
}

- (void)removeItem:(id <UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
    [self.animationOptions removeItem:item];
}

@end
