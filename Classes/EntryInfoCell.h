//
//  EntryInfoCell.h
//  StatDiary
//
//  Created by Peter Arato on 1/26/12.
//  Copyright (c) 2012 Pronovix. All rights reserved.
//



@interface EntryInfoCell : UITableViewCell {
	IBOutlet UILabel *titleLabel;
	IBOutlet UILabel *valueLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;

@end
