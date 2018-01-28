//
//  splitViewBarButtonItemPresenter.h
//  graphical calculator
//
//  Created by Wang Tom on 2018-01-22.
//  Copyright © 2018 Wang Tom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol splitViewBarButtonItemPresenter <NSObject>
@property (nonatomic, strong) UIBarButtonItem *navigationItem;
@property (nonatomic, strong) UIBarButtonItem *formulaBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *favoriteBarButtonItem;
@end
