//
//  DetailViewController.h
//  DevFriday
//
//  Created by Daniel Schneller on 30.08.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
