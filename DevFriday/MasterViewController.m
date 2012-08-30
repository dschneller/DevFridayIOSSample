//
//  MasterViewController.m
//  DevFriday
//
//  Created by Daniel Schneller on 30.08.12.
//  Copyright (c) 2012 codecentric AG. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"


// So called "private class extension"
// Anything declared in here is only visible inside this implementation
@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end


// Implementation. Base class "UITableViewController" is specified
// in the .h file
@implementation MasterViewController



// UIView lifecycle method. Called by the system once this instance
// has been loaded and can be configured to one's needs beyond what's
// already specified in the Storyboard file.
- (void)viewDidLoad
{
    [super viewDidLoad];

	// As we are embedded in a UINavigationController, we can simply
    // set some properties to configure the toolbar items.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // we want a custom ADD button, that's not available via a parent
    // class' properties or factory methods. So we create a new instance
    // of a UIBarButtonItem first.
    // It uses the system-provided UIBarButtonSystemItemAdd which is a
    // button with a plus-icon on it. When it's clicked it sends a message
    // to a target object (here: ourself). The message is "insertNewObject:".
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    
    // Then assign it to the ready-made rightBarButtonItem property
    self.navigationItem.rightBarButtonItem = addButton;
    
    // any static initialization of this instance is done, it is not
    // visible yet though. These settings will remain active as long
    // as the instance is available.
}

// Method that receives the message sent when the Add button is pressed.
// It receives the button as a parameter (sender) to distinguish between
// multiple possible senders.
- (void)insertNewObject:(id)sender
{
    // Lazy init of the model:
    // if the implementation-private "_objects" variable has not
    // been initialized yet (meaning it is still nil == 0 == NO), it is initialized
    // with a new mutable array
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    
    // add a new NSDate object with the current date into the array at
    // the first position. Elements already in the array will be pushed
    // down. The most current one is therefore always at index 0.
    [_objects insertObject:[NSDate date] atIndex:0];
    
    // Once the object has been inserted into the model, inform the
    // table view that there is a new element. Otherwise it would not
    // show up until the table was reloaded, e.g. when the view was
    // changed.
    
    // UITableView can have multiple sections (e. g. A,B,C,... in an address
    // list) with several rows each. A row is addressed by an index-path
    // Here we simply define that a new row is to be inserted in section 0,
    // row 0, meaning at the top of the table.
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

// Delegate method of the UITableView. It is asked how many sections
// the table has. In our case it is just a single section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Delegate method of the UITableView. It is asked how many entries
// the table has in the given section. The tableView is passed in,
// in case this controller is used to manage multiple table views.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // retur the number of elements in our model array
    return _objects.count;
}

// Delegate method of the UITableView. It is called when the table is
// drawing itself onto the screen. It asks for the graphics representation
// of a single table cell, specified by the indexPath parameter (section and row).
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view can create and cache instances of the desired cell
    // object by looking into its storyboard file and finding prototype cells
    // that have this specific identifier.
    // Depending on the cell's index path and the model different identifiers
    // and therefore different cells could be returned.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    // Once the cell is instantiated (or a cached one returned) we can assign
    // its value. To do so, we first retrieve the corresponding date object from
    // the model array. As we only have one section (which is always 0) the row
    // is enough to specify the row.
    NSDate *object = _objects[indexPath.row];
    
    // Stanard UITableViewCells have a few default properties, e. g. a simple
    // text label that can be used. Custom cells can have different properties,
    // of course. Here we just set the default text label to a string representation
    // of the NSDate object
    cell.textLabel.text = [object description];
    
    // return the cell to UIKit. It will then put it into the table.
    return cell;
}

// Table view delegate method. The table view asks for each row if its
// content should be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    // By returning YES for all row indexPaths, every cell is editable.
    return YES;
}

// Table view delegate method. The table view informs us that the specified
// row has been edited. The editingStyle parameter contains info about what has
// happened (delete, insert, update)
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // we just support deleting rows. This can happen through the default swipe
    // gesture or the default delete button.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // remove the underlying element from the model array
        [_objects removeObjectAtIndex:indexPath.row];
        // tell the table view to remove the element at that index to
        // make the change visible immediately.
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

// ...
// more methods exist, e. g. for re-arranging table cells by drag and drop.
// they would be responsible for mirroring the changes the user made to the
// graphics representation of the data back to the model array.
// ...


// Callback method for the system. Gets called when a Segue from the
// storyboard is about to be invoked. In our case this happens when the
// user taps on a table row cell. In the storyboard the segue is assigned
// an identifier, here "showDetail" that we can use to decide what to
// do in preparation.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        // 1. ask the table view for the index of the table row that
        //    was selected and is causing the segue
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        // 2. Get the corresponding NSDate from the model array by
        //    using the index of the selected cell.
        NSDate *object = _objects[indexPath.row];
        
        // 3. Get the segues destination controller and hand over
        //    the NSDate object. The target controller has already
        //    been instantiated from the storyboard at this point.
        [segue.destinationViewController setDetailItem:object];
        
        // NOTE: The concrete type (DetailViewController) of the
        //       destination controller is not known here! The
        //       segue.destinationViewController property is defined
        //       as type "id", which tells the compiler that we
        //       know what we are doing and don't want any type
        //       checking. Instead it allows us to send any message
        //       to the object behind that reference, in this case
        //       "setDetailItem:". If the object at the other end
        //       does not support this message at runtime, an
        //       exception would be thrown.
    }
}

#pragma mark - Rotation

// Delegate method that UIKit asks to known which orientations
// this view wants to/can support.
- (NSUInteger)supportedInterfaceOrientations
{
    // return a value that says "anything that is not upside down (home button on top)".
    // (nobody really knows why this is an orientation the styleguide disencourages,
    //  while on the iPad it is perfectly fine).
    //
    // The support is based on the flexibility and resizability of the UI elements
    // that are defined in the storyboard
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// Delegate method that UIKit asks to see if this view supports
// automatic rotation at all. If so, it will also ask for the supportedInterfaceoOrientations.
- (BOOL)shouldAutorotate
{
    return YES;
}


@end
