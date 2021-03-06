#import "SwrveConversationResource.h"
#import "SwrveInputMultiBase.h"
#import "SwrveSetup.h"
#import "SwrveConversationStyler.h"

@interface SwrveInputMultiBase () {
    UIView* containerView;
}
@end

@implementation SwrveInputMultiBase

@synthesize values;
@synthesize description;

-(void) loadViewWithContainerView:(UIView*)cw {
    containerView = cw;
    // Note: A multivalue can only be used in a table, so it doesn't load a view as such
    [[NSNotificationCenter defaultCenter] postNotificationName:kSwrveNotificationViewReady object:nil];
}

-(BOOL)hasDescription {
    return self.description != nil;
}

-(NSUInteger) numberOfRowsNeeded {
    return self.values.count + ([self hasDescription]? 1: 0);
}

-(UITableViewCell*) styleCell:(UITableViewCell *)cell atRow:(NSUInteger) row {
    NSString *imageName;
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        cell.backgroundView = [[UIImageView alloc] initWithImage:nil];
    } else {
        if(row == 0) {
            // Potentially a top row
            if(self.values.count == 1) {
                // Its actually a top + bottom
                imageName = @"grouped_cell_single_ios7";
            } else {
                // Actually a top
                imageName = @"grouped_cell_top_ios7";
            }
        } else {
            // Not a top row
            if(row == self.values.count-1) {
                // It is a bottom row
                imageName = @"grouped_cell_bottom_ios7";
            } else {
                // Must be a mid, yo
                imageName = @"grouped_cell_mid_ios7";
            }
        }
        UIImage *img = [SwrveConversationResource imageFromBundleNamed:imageName];
        cell.backgroundView = [[UIImageView alloc] initWithImage:img];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:nil];
    }
    return cell;
}

-(CGFloat) heightForRow:(NSUInteger) row {
    if (row == 0) {
        UIFont *uifont = [UIFont boldSystemFontOfSize:20.0];
        CGFloat constrainedWidth = containerView.frame.size.width;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            constrainedWidth = (constrainedWidth - 100);
        } else {
            constrainedWidth = (constrainedWidth - 155);
        }

        CGSize possibleSize = [self.description sizeWithFont:uifont
                                           constrainedToSize:CGSizeMake(constrainedWidth, 9999)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat h = (float)ceil(possibleSize.height);
        return h;
    } else {
        return 51.0;
    }
}

-(UITableViewCell*) fetchDescriptionCell:(UITableView*)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"descriptionCell"];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"descriptionCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
        cell.userInteractionEnabled = NO;
    }
    cell.textLabel.text = self.description;
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    cell.textLabel.numberOfLines = 0;
    [SwrveConversationStyler styleView:cell withStyle:self.style];
    return cell;
}

-(UITableViewCell*) fetchStandardCell:(UITableView*)tableView {
    NSString *cellId = [NSString stringWithFormat:@"%@CellId", self.type];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return cell;
}

@end
