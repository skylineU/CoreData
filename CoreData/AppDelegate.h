//
//  AppDelegate.h
//  CoreData
//
//  Created by yun on 2018/7/30.
//  Copyright © 2018年 yun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
/**
 * 在应用程序中封装Core Data堆栈的容器。
 NSPersistentContainer通过处理托管对象模型（NSManagedObjectModel），持久性存储协调器（NSPersistentStoreCoordinator）和托管对象上下文（NSManagedObjectContext）的创建，简化了Core Data堆栈的创建和管理。
 */
@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

