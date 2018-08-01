//
//  School+CoreDataProperties.h
//  
//
//  Created by yun on 2018/8/1.
//
//

#import "School+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface School (CoreDataProperties)

+ (NSFetchRequest<School *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *schoolName;
@property (nullable, nonatomic, retain) NSSet<Student *> *schoolStudents;

@end

@interface School (CoreDataGeneratedAccessors)

- (void)addSchoolStudentsObject:(Student *)value;
- (void)removeSchoolStudentsObject:(Student *)value;
- (void)addSchoolStudents:(NSSet<Student *> *)values;
- (void)removeSchoolStudents:(NSSet<Student *> *)values;

@end

NS_ASSUME_NONNULL_END
