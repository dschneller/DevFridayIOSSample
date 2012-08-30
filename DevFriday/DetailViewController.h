//
//  DetailViewController.h
//  DevFriday
//
//  Created by Daniel Schneller on 30.08.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import <UIKit/UIKit.h>

// public definition of the DetailViewController class. It extends the UIViewController base class
@interface DetailViewController : UIViewController

// property used to store the element that is to be shown. Its type is "id" so it
// can store a reference to any object.
@property (strong, nonatomic) id detailItem;

// InterfaceBuilder Outlet. This provides programmatic access to the label that
// was placed on this controller's view and connected by drag and drop.
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

- (IBAction)rotateLabel:(id)sender;


@end
