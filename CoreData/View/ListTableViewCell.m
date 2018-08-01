//
//  ListTableViewCell.m
//  CoreData
//
//  Created by yun on 2018/7/31.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "ListTableViewCell.h"

@interface ListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;
@property (weak, nonatomic) IBOutlet UILabel *mathLabel;
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *schoolLabel;


@end

@implementation ListTableViewCell

- (void)setupWithModel:(Student *)model{
    self.nameLabel.text = [NSString stringWithFormat:@"姓名:%@",model.name];
    self.ageLabel.text = [NSString stringWithFormat:@"年龄:%d",model.age];
    self.chineseLabel.text = [NSString stringWithFormat:@"语文:%d",model.chinese];
    self.mathLabel.text = [NSString stringWithFormat:@"数学:%d",model.math];
    self.englishLabel.text = [NSString stringWithFormat:@"英语:%d",model.english];
    self.schoolLabel.text = model.studentSchool.schoolName;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
