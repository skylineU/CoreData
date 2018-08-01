//
//  ListViewController.m
//  CoreData
//
//  Created by yun on 2018/7/31.
//  Copyright © 2018年 yun. All rights reserved.
//

#import "ListViewController.h"
#import "ListTableViewCell.h"
#import "EnterDataViewController.h"

#import "AppDelegate.h"

@interface ListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) AppDelegate *app;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation ListViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getCoreDataMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchData)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addData)];
    self.dataArray = [NSMutableArray array];
    self.app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSLog(@"%@", paths[0]);
}

// 获取所有数据
- (void)getCoreDataMessage{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Student" inManagedObjectContext:_app.persistentContainer.viewContext];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"<#format string#>", <#arguments#>];
//    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"<#key#>"
//                                                                   ascending:YES];
//    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [_app.persistentContainer.viewContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"error");
    } else {
        [self.dataArray removeAllObjects];
        self.dataArray = [fetchedObjects mutableCopy];
        [self.tableView reloadData];
    }
    
}

#pragma mark -- action

- (void)searchData{
    
}

- (void)addData{
    EnterDataViewController *vc = [[EnterDataViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -- tableView代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        [cell setupWithModel:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EnterDataViewController *vc = [[EnterDataViewController alloc] init];
    vc.stu = _dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return YES;
//}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 删除数据
        Student *stu = _dataArray[indexPath.row];
        [_app.persistentContainer.viewContext deleteObject:stu];
        [_app saveContext];// 任何操作都需要保存
        
        [_dataArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *
 A.ab->B :A对象指向B的删除关系ab被设置为:
 
 No Action:当A被删除时,B对象不变,但会指向一个不存在的对象,一般不建议使用;
 
 Nullify(作废):当A对象被删除时,B对象指向的A对象会置为空,如果A与B的关系式一对多,则是A对象从B容器中移除
 
 Cascade(级联):当A对象被删除时,A对象指向的B对象也会被删除;
 
 Deny(拒绝):当删除指向对象B存在的A对象时,操作将会被拒绝;
 
 
 下面通过一个例子来说明这四个类型都有什么效果：
 
 假如我们删除一名学生，
 如果把 Delete Rule 设置成 No Action，它表示不做任何，这个时候学生所在的班级（Class.classStudents）依然会以为这名学生还在这个班级里，同时课程记录里也会以为学习这门课程（Course.courseStudents）的所有学生们里，还有这位学生，当我们访问到这两个属性时，就会出现异常情况，所以不建议设置这个规则；
 如果设置成 Nullify，对应的，班级信息里就会把这名学生除名，课程记录里也会把这名学生的记录删除掉；
 如果设置成 Cascade，它表示级联操作，这个时候，会把这个学生关联的班级以及课程，一股脑的都删除掉，
 如果 Clazz 和 Course 里还关联着其他的表，而且也设置成 Cascade 的话，就还会删除下去；如果设置成 Deny，只有在学生关联的班级和课程都为 nil的情况下，这个学生才能被删除，否则，程序就会抛出异常。
 所以这里，我们把 Student 的 studentClass 和 studentCourses 的删除规则设置成 Nullify 是最合适的。
 
 
 关于Core Data属性类型，玉令博客中一段比较全面的解释：
 
 1： Undefined选项值是新创建的属性的默认类型；如果属性类型为undefined，项目将无法通过编译。
 
 2： Integer 16/32/64只表示整数，没有小数点。所以如果10除以3，你将会得到3，而余数1会丢失。Integer 16/32/64之间唯一的区别是所表示的数值范围不同。因为Core Data使用符号数，所以起始范围是负数，而不是0。
 Integer 16 数值范围：-32768~32767；
 Integer 32 数值范围：-2147483648~2147483647；
 Integer 64 数值范围：–9223372036854775808~9223372036854775807。
 标准整型数的最大值和最小值可以在stdint.h中找到。在任何类文件中输入INT32_MAX,选中右击，然后选择Jump To Definition，你将看到许多最大值最小值定义。实体的属性的类型是Integer 16/32/64，当创建此实体对应的NSManagedObject子类时，属性最终的类型将会是NSNumber。
 
 3：Double和Float可以认为是有小数部分的整数。它们都是基于二进制数值系统，在CPU运算时很可能会发生舍入误差。比如1/5，如果使用十进制数值系统，可以精确表示为0.2.但在二进制数值系统中，只能表示一个大概，在小数部分你会得到大量数字。所以不要使用Integer、Double、Float表示货币值。计算精度越高则越加趋于准确值，但内存占用也会越大。一个Float数使用32bit进行存储，一个Double数使用64bit。它们都使用科学计数法进行存储，所以一个数包含尾数和指数部分
 
 在iOS中，最大的Float值是340282346638528859811704183484516925440.000000，最小的Float值是340282346638528859811704183484516925440.000000Double和Float都有一个符号位。而Double比Float的数值范围更大。
 
 当你决定该选择Float还是Double时，想一下你的属性是否真的需要超过Float提供的7位精度，如果不是，你应该选择Float，因为它更加匹配64bit的iPhone 5S底层处理器。除此之外，如果你想增加浮点数的计算速度而精度并没有严格要求，Float也是最佳选择。实体的属性的类型是Float或Double，当创建此实体对应的NSManagedObject子类时，属性最终的类型将会是NSNumber。
 
 4：Decimal（十进制）是处理货币值和其他需要十进制场合下最佳选择，Decimal提供了优秀的计算精度，也消除了计算过程中的舍入误差。因为CPU的本地数制是二进制，所以CPU在处理十进制数时，开销会多一点。实体的属性的类型是Decimal，当创建此实体对应的NSManagedObject子类时，属性最终的类型将会是NSDecimalNumber。当你使用NSDecimalNumber执行计算时(如加减乘除计算)，为了保证计算精度，你只能使用它提供的内建方法。更多关于NSDecimalNumber可参见这里。
 
 5：String类型和Objective-C中的NSString类似，用于保存字符数组。当生成实体对应的NSManagedObject子类时，String属性被表示为NSString。
 
 6：Boolean数据类型被用于表示YES/NO值。当生成实体对应的NSManagedObject子类时，Boolean数据类型会被表示为NSNumber。所以为了获取布尔值，你需要想NSNumber对象发送boolValue消息。
 
 7：Date类型是自解释类型。用来存储日期和时间。当生成实体对应的NSManagedObject子类时，Date类型会被表示为NSDate。
 
 8：Binary Data用来表示照片，音频，或一些BLOB类型数据(“Binary Large OBjects” such as image and sound data)。当生成实体对应的NSManagedObject子类时，Binary Data数据类型会被表示为NSData。
 
 9：Transformable属性类型用于存储一个Objective-C对象。该属性类型允许你存储任何类的实例，比如你使用Transformable属性表示UIColor。当生成NSManagedObject子类时，Transformable类型会被表示为id。对于id对象的保存和解档需要使用一个NSValueTransformer的实例或子类的实例。由该类负责属性值与NSData之间的转换。但这也相当的简单，尤其是当属性值的类型已经实现了NSCoding协议，此时系统会自动提供一个默认的NSValueTransformer实例来完成归档和解档。
 
 
 
 CoreData 栈是 CoreData 初始化被访问的框架对象的集合，以及应用中数据对象和外部数据存储的媒介。CoreData 的初始化需要一步步地初始化 CoreData 栈上的三个对象结构，它们分别是：
 
 NSManagedObjectModel — 描述了数据模型的结构信息
 NSPersistentStoreCoordinator — 数据持久层和内存对象模型的协调器
 NSManagedObjectContext — 内存中 managedObject 对象的上下文
 
 CoreData自动生成Entity+CoreDataClass和Entity+CoreDataProperties，需要处理数据只要导入CoreDataClass就好了。CoreDataProperties里包含设置的model属性(attribute)和+ (NSFetchRequest<Student *> *)fetchRequest（用于从持久性存储中检索数据的搜索条件的描述）。也可以手动生成，codegen设置为Manual/None，选中.xcdatamodeld->Editor->Add NSManagedObject Subclass...
 

 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
