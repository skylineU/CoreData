//
//  Student+CoreDataProperties.h
//  
//
//  Created by yun on 2018/8/1.
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
// School和Student表关联起来后，设置relationship后生成的属性（type设置为To One）
@property (nullable, nonatomic, retain) School *studentSchool;

@end

NS_ASSUME_NONNULL_END
