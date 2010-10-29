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
#import "Project.h"

@implementation RuleViewController


- (void)viewDidLoad {
	[super viewDidLoad];
	tableView.allowsSelection = NO;
	tableView.sectionHeaderHeight = 20;
}




#pragma mark -
#pragma mark Table view data source

// custom view for header. will be adjusted to default or specified header height
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 25)];
	label.font = [UIFont fontWithName:PrimaryFontName size:20];
	label.textColor = [UIColor grayColor];
	label.backgroundColor = [GameVisual colorWithHex:NoteViewBackgroundColor];

	if (section == 0) {
		label.text = @"Projects";
	}else {
		label.text = @"Badges";
	}

	return label;
	
}  




// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return NumberOfRumbleTargetTypes;
	}else {
		return NumberOfBadgeTypes;
	}
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)_tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	// Configure the cell.	
	cell.textLabel.font = [UIFont fontWithName:SecondaryFontName size:25];
	cell.textLabel.textColor = [GameVisual scoreColor];
	
	cell.detailTextLabel.font = [UIFont fontWithName:SecondaryFontName size:15];
	cell.detailTextLabel.textColor = [UIColor grayColor];
	cell.detailTextLabel.numberOfLines = 2;
	
	
	if (indexPath.section == 0) {
		RumbleTargetType type = indexPath.row;
		cell.textLabel.text = [NSString stringWithFormat:@"+%d",[Project scoreForRumbleTargetType:type]];
		cell.detailTextLabel.text = [Project shortDescriptionForRumbleTargetType:type];	
		cell.imageView.image = [GameVisual imageForRumbleType:type];			
		
	}else{
		//Badge Type is not continuous, so we need to have an array for that
		BadgeType type = BadgeTypes[indexPath.row];	
		cell.textLabel.text = [NSString stringWithFormat:@"+%d",[GameLogic scoreForBadgeType:type]];
		cell.detailTextLabel.text = [GameLogic shortDescriptionForBadgeType:type];	
		cell.imageView.image = [GameVisual imageForBadgeType:type];	
	}
	
	
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
