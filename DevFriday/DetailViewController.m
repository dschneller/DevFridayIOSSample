//
//  DetailViewController.m
//  DevFriday
//
//  Created by Daniel Schneller on 30.08.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import "DetailViewController.h"

// Private class extension. The method "configureView" is only visible
// inside this implementation.
@interface DetailViewController ()
- (void)configureView;
@end


@implementation DetailViewController

#pragma mark - Managing the detail item

// Setter for the public property "detailItem" (declared in the @interface in the
// .h file). This is called when the MasterViewController's
// prepareForSegue:sender: method executes the line
//
//         [segue.destinationViewController setDetailItem:object];
//
// As the type of "newDetailItem" is "id", any object can be passed
// in as a parameter. It is up to the developer to do the right thing
- (void)setDetailItem:(id)newDetailItem
{
    // check if the _instance variable_ (field) backing
    // the detailItem property is identical to the object
    // that was just passed in. If not, set it to the new
    // arrival and call the configureView method.
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    // NOTE: This method is the setter for the detailItem property,
    //       so it is responsible for managing the content of the
    //       _detailItem variable which in this case backs the property.
    //       This need not be the case, properties could also be
    //       "transient" and not be backed by any concrete private
    //       field at all.
}

// Updates the detail view's UI
- (void)configureView
{
    // if the detailItem property is != nil (<=> !=0 <=> YES)
    if (self.detailItem) {
        // send the "description" method to whatever object was
        // passed in via the setter. As it is of type "id" the compiler
        // just takes from granted, that it will be able to handle it
        // and return an NSString* (which is what the label's text
        // property expects). If it does not, an exception will be
        // thrown. However in this case we're quite safe, because description
        // is declard and implemented in the NSObject class and therefore
        // guaranteed to be available in any class extending it directly
        // or indirectly.
        NSString* textToDisplay = [self.detailItem description];

        // Assign the UILabel's text property. This will make the
        // text appear on the screen.
        self.detailDescriptionLabel.text = textToDisplay;
    }
}

// same customization method as in the MasterViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

// same rotation callbacks as in the MasterViewController
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

@end
