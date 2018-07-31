//
//  EnterDataViewController.m
//  CoreData
//
//  Created by yun on 2018/7/31.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "EnterDataViewController.h"
#import "Student+CoreDataClass.h"
#import "AppDelegate.h"

@interface EnterDataViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
@property (weak, nonatomic) IBOutlet UITextField *chineseTF;
@property (weak, nonatomic) IBOutlet UITextField *mathTF;
@property (weak, nonatomic) IBOutlet UITextField *englishTF;

@property(nonatomic,strong) AppDelegate *app;


@end

@implementation EnterDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveData)];
    self.app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (_stu) {
        _nameTF.text = _stu.name;
        _ageTF.text = [NSString stringWithFormat:@"%d",_stu.age];
        _chineseTF.text = [NSString stringWithFormat:@"%d",_stu.chinese];
        _mathTF.text = [NSString stringWithFormat:@"%d",_stu.math];
        _englishTF.text = [NSString stringWithFormat:@"%d",_stu.english];
    }
}

#pragma mark -- action
- (void)saveData{
    
    if (_nameTF.text.length <= 0) {
        NSLog(@"请输入姓名");
        return;
    }
    if (_ageTF.text.length <= 0) {
        NSLog(@"请输入年龄");
        return;
    }
    if (_chineseTF.text.length <= 0) {
        NSLog(@"请输入语文成绩");
        return;
    }
    if (_mathTF.text.length <= 0) {
        NSLog(@"请输入数学成绩");
        return;
    }
    if (_englishTF.text.length <= 0) {
        NSLog(@"请输入英语成绩");
        return;
    }
    
    if (_stu) {// 修改
        // 数据量大的话，内存会溢出。这时用NSBatchUpdateRequest来做批量更新
        _stu.name = _nameTF.text;
        _stu.age = [_ageTF.text intValue];
        _stu.chinese = [_chineseTF.text intValue];
        _stu.math = [_mathTF.text intValue];;
        _stu.english = [_englishTF.text intValue];
        
    } else { // 插入数据
        Student *stu = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:_app.persistentContainer.viewContext];
        stu.name = _nameTF.text;
        stu.age = [_ageTF.text intValue];
        stu.chinese = [_chineseTF.text intValue];
        stu.math = [_mathTF.text intValue];;
        stu.english = [_englishTF.text intValue];
        
    }
    
    [_app saveContext];
    [self removeContent];
}

- (void)removeContent{
    _nameTF.text = @"";
    _ageTF.text = @"";
    _chineseTF.text = @"";
    _mathTF.text = @"";
    _englishTF.text = @"";
}


// 批量更新
- (void)batchUpdate{
    NSBatchUpdateRequest *request = [NSBatchUpdateRequest batchUpdateRequestWithEntityName:@"Student"];
    // 条件
    request.predicate = [NSPredicate predicateWithFormat:@"age > 16"];
    // 更新字段对应的value
    request.propertiesToUpdate = @{@"name":@"明明"};
    
    request.resultType = NSUpdatedObjectIDsResultType;
//    request.affectedStores
    
    NSError *requestError;
    NSBatchUpdateResult *updataResult = [_app.persistentContainer.viewContext executeRequest:request error:&requestError];
    NSArray<NSManagedObjectID *> *updatedObjectIDs = updataResult.result;
    /**
     * 处理来自其他进程或序列化状态的更改。
     
     此方法更有效地将更改合并到多个上下文以及嵌套上下文中。 字典键应该是NSManagedObjectContextObjectsDidChangeNotification中的一个或多个：NSInsertedObjectsKey，NSUpdatedObjectsKey，NSDeletedObjectsKey。 值应该是符合URIRepresentation有效结果的NSManagedObjectID或NSURL对象的NSArray。
     */
    /// 底层数据更新之后，现在要通知内存中的 context
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSUpdatedObjectsKey:updatedObjectIDs} intoContexts:@[_app.persistentContainer.viewContext]];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self batchDelete];
}

// 批量删除
- (void)batchDelete{
    NSFetchRequest *fetch = [Student fetchRequest];//CoreDataProperties的一个方法
    fetch.predicate = [NSPredicate predicateWithFormat:@"age == 16"];
    
    NSBatchDeleteRequest *request = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetch];
    request.resultType = NSUpdatedObjectIDsResultType;
    
    NSBatchDeleteResult *deleteResult = [_app.persistentContainer.viewContext executeRequest:request error:nil];
    NSArray<NSManagedObjectID *> *deletedObjectIDs = deleteResult.result;
    [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey:deletedObjectIDs} intoContexts:@[_app.persistentContainer.viewContext]];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
