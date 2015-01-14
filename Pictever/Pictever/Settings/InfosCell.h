//
//  InfosCell.h
//  Shyft
//
//  Created by Gauthier Petetin on 23/10/2014.
//  Copyright (c) 2014 Gauthier Petetin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfosCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *backGroundLabel1;
@property (weak, nonatomic) IBOutlet UILabel *backGroundLabel2;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailContentLabelbis;
@property (weak, nonatomic) IBOutlet UILabel *emailTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *infosImgv;
@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;

@end