//
//  Student+CoreDataProperties.m
//  
//
//  Created by yun on 2018/8/1.
//
//

#import "Student+CoreDataProperties.h"

@implementation Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Student"];
}

@dynamic age;
@dynamic chinese;
@dynamic english;
@dynamic math;
@dynamic name;
@dynamic studentSchool;

@end
