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

#pragma mark - Interface Rotation
// same rotation callbacks as in the MasterViewController
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - Label Animation

// The button in the storyboard will send this message
// when it is tapped and pass itself along as the sender.
- (IBAction)rotateLabel:(id)sender {
    // we don't care about who sent the message, we
    // just call the animateTheLabel method
    [self animateTheLabel];
}

- (void)animateTheLabel
{
    // Tell the view to begin an animation. It is
    // to take 1.0 seconds to complete. The animations
    // block can be used to change any animatable
    // property of any element on the UI. Programmatically
    // the changes happen immediately, but the system
    // will take care of changing the values gradually
    // over the course of the animation duration.
    [UIView animateWithDuration:1.0f animations:^{
        CGAffineTransform rotation = CGAffineTransformMakeRotation(M_PI); // 180 degress
        CGAffineTransform scaling = CGAffineTransformMakeScale(2.0f, 2.0f); // 2xWidth and Height
        self.detailDescriptionLabel.transform = CGAffineTransformConcat(rotation, scaling);
    }];
}

@end
