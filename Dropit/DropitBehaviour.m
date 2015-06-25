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
@end

@implementation DropitBehaviour

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc]init];
        _gravity.magnitude = 0.9;
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

- (instancetype)init
{
    self = [super init];
    
    [self addChildBehavior:self.gravity];
    [self addChildBehavior:self.collider];
    
    return self;
}

- (void)   addItem:(id <UIDynamicItem>)item
{
    [self.gravity addItem:item];
    [self.collider addItem:item];
}
- (void)removeItem:(id <UIDynamicItem>)item
{
    [self.gravity removeItem:item];
    [self.collider removeItem:item];
}

@end
