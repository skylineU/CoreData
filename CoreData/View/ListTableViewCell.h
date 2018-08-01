//
//  ListTableViewCell.h
//  CoreData
//
//  Created by yun on 2018/7/31.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student+CoreDataClass.h"
#import "School+CoreDataClass.h"

@interface ListTableViewCell : UITableViewCell

- (void)setupWithModel:(Student *)model;

@end
