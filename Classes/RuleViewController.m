//
//  RuleViewController.m
//  BoardGame
//
//  Created by Liz on 10-6-30.
//  Copyright 2010 StupidTent co. All rights reserved.
//

#import "RuleViewController.h"
#import "GameVisual.h"
#import "GameLogic.h"

@implementation RuleViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	tableView.allowsSelection = NO;
}




#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return NumberOfBadgeTypes;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.
	BadgeType type = BadgeTypes[indexPath.row];	
	
	cell.textLabel.font = [UIFont fontWithName:SecondaryFontName size:25];
	cell.textLabel.textColor = [GameVisual scoreColor];
	cell.textLabel.text = [NSString stringWithFormat:@"+%d",[GameLogic scoreForBadgeType:type]];
	
	cell.detailTextLabel.font = [UIFont fontWithName:SecondaryFontName size:15];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	cell.detailTextLabel.numberOfLines = 2;
	cell.detailTextLabel.text = [GameLogic descriptionForBadgeType:type];	
	
	cell.imageView.image = [GameVisual imageForBadgeType:type];	
	
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark -
#pragma mark Table view delegate
/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
 }
 
 */




- (void)dealloc {
    [super dealloc];
}


@end
