//
//  School+CoreDataProperties.m
//  
//
//  Created by yun on 2018/8/1.
//
//

#import "School+CoreDataProperties.h"

@implementation School (CoreDataProperties)

+ (NSFetchRequest<School *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"School"];
}

@dynamic schoolName;
@dynamic schoolStudents;

@end
