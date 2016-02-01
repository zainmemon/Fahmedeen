//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "Bayan.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, strong) NSArray *type;
@end

@implementation SidebarViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
<<<<<<< HEAD
    _menuItems = @[@"",@"Sunday Bayanaat", @"Bayanaat", @"Morning Dars", @"Mufti Taqi Usmani",@"Ramzan Bayanaat",@"Others"];
    _type = @[@"",@"sunday",@"bayans",@"morning",@"tusmani",@"ramdhan",@"others"];
    
    self.sidebarTableView.tableFooterView = [UIView new];
=======
    
    _menuItems = @[@"Sunday Bayanaat", @"Friday Bayanaat", @"Morning Dars", @"Mufti Taqi Usmani",@"Ramzan Bayanaat", @"Nazmain", @"Others"];
>>>>>>> origin/master
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
<<<<<<< HEAD
    if (indexPath.row > 0) {
        if ([segue.identifier isEqualToString:@"show"]) {
            Bayan *b = (Bayan*)segue.destinationViewController;
            b.title = [[self.menuItems objectAtIndex:indexPath.row] capitalizedString];
            b.type = [self.type objectAtIndex:indexPath.row];
        }
        
        if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
            SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
=======
    
    if ([segue.identifier isEqualToString:@"show"]) {
        Bayan *b = (Bayan*)segue.destinationViewController;
        b.title = [[self.menuItems objectAtIndex:indexPath.row] capitalizedString];
        
        if(indexPath.row ==0)
        {
            b.bayanCategory = @"sunday";
        }
        else if (indexPath.row == 1)
        {
            b.bayanCategory = @"bayans";
        }
        else if (indexPath.row == 2)
        {
            b.bayanCategory = @"morning";
        }
        else if (indexPath.row == 3)
        {
            b.bayanCategory = @"tusmani";
        }
        else if (indexPath.row == 4)
        {
            b.bayanCategory = @"ramdhan";
        }
        else if (indexPath.row == 5)
        {
            b.bayanCategory = @"nazam";
        }
        else
        {
            b.bayanCategory = @"others";
        }
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] )
    {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc)
        {
>>>>>>> origin/master
            
            swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
                
                UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
                [navController setViewControllers: @[dvc] animated: NO ];
                [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
            };
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"listitem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    return cell;
}

@end
