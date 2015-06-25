//
//  DropitBehaviour.h
//  Dropit
//
//  Created by Cristiana on 25/06/15.
//  Copyright (c) 2015 Cristiana. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropitBehaviour : UIDynamicBehavior

- (void)addItem:(id <UIDynamicItem>)item;
- (void)removeItem:(id <UIDynamicItem>)item;

@end
