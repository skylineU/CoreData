//
//  Student+CoreDataProperties.h
//  
//
//  Created by yun on 2018/8/2.
//
//

#import "Student+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Student (CoreDataProperties)

+ (NSFetchRequest<Student *> *)fetchRequest;

@property (nonatomic) int16_t age;
@property (nonatomic) int16_t chinese;
@property (nonatomic) int16_t english;
@property (nonatomic) int16_t math;
@property (nullable, nonatomic, copy) NSString *name;
@property (nonatomic) BOOL sex;
@property (nullable, nonatomic, retain) School *studentSchool;

@end

NS_ASSUME_NONNULL_END
