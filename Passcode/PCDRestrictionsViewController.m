//
//  PCDRestrictionsViewController.m
//  Passcode
//
//  Created by Matt on 5/25/13.
//  Copyright (c) 2013 Matt Zanchelli. All rights reserved.
//

#import "PCDRestrictionsViewController.h"

@interface PCDRestrictionsViewController () {
	NSMutableArray *listOfItems;
	NSMutableArray *listOfAccessories;
	UISlider *lengthSlider;
}

@end

@implementation PCDRestrictionsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		[self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self setup];
	}
	return self;
}

- (id)init
{
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup
{
	self.title = NSLocalizedString(@"Restrictions", @"Restrictions");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Done button to dismiss view controller
	UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
																		  target:self
																		  action:@selector(done:)];
	[self.navigationItem setLeftBarButtonItem:done];
	
	// Invisible right bar button to also dismiss view controller
	UIButton *invisible = [UIButton buttonWithType:UIButtonTypeCustom];
	[invisible setTitle:done.title forState:UIControlStateNormal];
	// Would be nice not having to hard-code in width and height
	[invisible setFrame:CGRectMake(0, 0, 55, 32)];
	[invisible setShowsTouchWhenHighlighted:YES];
	UIBarButtonItem *secretlyDone = [[UIBarButtonItem alloc] initWithCustomView:invisible];
	[invisible addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
	[self.navigationItem setRightBarButtonItem:secretlyDone];
	
	[self.view setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.0f]];
	
	// Initialize the arrays
	listOfItems = [[NSMutableArray alloc] init];
	listOfAccessories = [[NSMutableArray alloc] init];
	
	NSDictionary *lengthDict = [NSDictionary dictionaryWithObject:@[@""] forKey:@"Restrictions"];
	[listOfItems addObject:lengthDict];
	
	lengthSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 280, 22)];
	[lengthSlider setMinimumValue:4.0f];
	[lengthSlider setMaximumValue:28.0f];
	[lengthSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
	[lengthSlider addTarget:self action:@selector(sliderStopped:) forControlEvents:UIControlEventTouchUpInside];
	NSArray *lengthViewDict = [NSDictionary dictionaryWithObject:@[lengthSlider] forKey:@"Restrictions"];
	[listOfAccessories addObject:lengthViewDict];
	
	NSArray *restrictionTypes = @[@"Capitals", @"Numbers", @"Symbols", @"No Consecutives"];
	NSDictionary *restrictionTypesDict = [NSDictionary dictionaryWithObject:restrictionTypes forKey:@"Restrictions"];
	[listOfItems addObject:restrictionTypesDict];
	
	UISwitch *capitalsSwitch = [[UISwitch alloc] init];
	[capitalsSwitch setOn:YES];
	
	UISwitch *numbersSwitch = [[UISwitch alloc] init];
	[numbersSwitch setOn:YES];
	
	UISwitch *symbolsSwitch = [[UISwitch alloc] init];
	[symbolsSwitch setOn:YES];
	
	UISwitch *consecutiveCharsSwitch = [[UISwitch alloc] init];
	[consecutiveCharsSwitch setOn:YES];
	
	NSArray *restrictionAccessoryViews = @[capitalsSwitch, numbersSwitch, symbolsSwitch, consecutiveCharsSwitch];
	NSDictionary *restrictionAccessoryViewsDict = [NSDictionary dictionaryWithObject:restrictionAccessoryViews forKey:@"Restrictions"];
	[listOfAccessories addObject:restrictionAccessoryViewsDict];
	
	[_tableView setDataSource:self];
	UIView *backgroundView = [[UIView alloc] init];
	[backgroundView setBackgroundColor:[UIColor colorWithWhite:0.93f alpha:1.0f]];
	[_tableView setBackgroundView:backgroundView];
	
	UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
	[footerView setTextAlignment:NSTextAlignmentCenter];
	[footerView setNumberOfLines:2];
	[footerView setFont:[UIFont systemFontOfSize:14.0f]];
	[footerView setTextColor:[UIColor lightGrayColor]];
	[footerView setShadowColor:[UIColor whiteColor]];
	[footerView setShadowOffset:CGSizeMake(0, 1)];
	[footerView setBackgroundColor:[UIColor clearColor]];
	[footerView setText:@"Using definitions for \"Apple\"\nLast updated April 1, 2013 9:42 AM"];
	[_tableView setTableFooterView:footerView];
}

- (void)done:(id)sender
{
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark Restrictions

- (void)sliderValueChanged:(id)sender
{
    [self updateSliderPopoverText];
}

- (void)updateSliderPopoverText
{
//    lengthSlider.popover.textLabel.text = [NSString stringWithFormat:@"%.0f", lengthSlider.value];
}

- (void)sliderStopped:(id)sender
{
	// Set the value of the slider to the nearest whole number.
	// Is this necessary? Perhaps just handle the rounding when making the passcode?
	
	//	NSLog(@"%f", lengthSlider.value);
	[lengthSlider setValue:roundf(lengthSlider.value) animated:YES];
	//	NSLog(@"%f", lengthSlider.value);
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [listOfItems count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	// Number of rows it should expect should be based on the section
	NSDictionary *dictionary = [listOfItems objectAtIndex:section];
    NSArray *array = [dictionary objectForKey:@"Restrictions"];
	return [array count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	switch ( section ) {
		case 0: return @"Length";
		case 1: return @"Restrictions";
		default: return @"";
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
									  reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
	
	// First get the text values
	NSDictionary *values = [listOfItems objectAtIndex:indexPath.section];
	NSArray *valuesArray = [values objectForKey:@"Restrictions"];
	NSString *cellValue = [valuesArray objectAtIndex:indexPath.row];
	[cell.textLabel setText:cellValue];
//	[cell.textLabel setTextColor:[UIColor colorWithRed:32.0f/255.0f green:74.0f/255.0f blue:171.0f/255.0f alpha:1.0f]];
	
	NSDictionary *accessories = [listOfAccessories objectAtIndex:indexPath.section];
	NSArray *accessoryArray = [accessories objectForKey:@"Restrictions"];
	UIView *accessoryView = [accessoryArray objectAtIndex:indexPath.row];
	[cell setAccessoryView:accessoryView];
	
    return cell;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)tableView
		 accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellAccessoryDisclosureIndicator;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Tapped %@", indexPath);
//	[self tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	[self setTableView:nil];
}

@end