//
//  ViewController.m
//  QuickLookDemo
//
//  Created by Jason on 2017/7/31.
//  Copyright © 2017年 Jason. All rights reserved.
//

#import "ViewController.h"
#import <QuickLook/QuickLook.h>  

@interface ViewController ()<QLPreviewControllerDelegate,QLPreviewControllerDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(TapAction)];
    [self.view addGestureRecognizer:tap];
    [self movePath];

}
- (void)createFilePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *caches = [[paths firstObject] stringByAppendingString:@"/Documents"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:caches]){//判断dirPath路径文件夹是否已存在，此处dirPath为需要新建的文件夹的绝对路径
        
        [[NSFileManager defaultManager] createDirectoryAtPath:caches withIntermediateDirectories:YES attributes:nil error:nil];//创建文件夹
    }
}
- (void)TapAction{
    [self gotoFile];
}
-(void)gotoFile
{
    QLPreviewController *qlViewController = [[QLPreviewController alloc] init];
    qlViewController.dataSource = self;
    [self.navigationController pushViewController:qlViewController animated:YES];
}

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return 2                                                    ;
}
- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller
                     previewItemAtIndex:(NSInteger)index{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    if (!documentsDirectory) {
        NSLog(@"Documents directory not found!");//return ;
    }
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"test.doc"];
//    NSURL *myQLDocument = [NSURL fileURLWithPath:appFile];
    ;
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"MSRC-iOS-1.0.0.0研发转测试发布说明" ofType:@"doc"];
    NSURL *myQLDocument = [NSURL fileURLWithPath:docPath];
    return myQLDocument;                    
}

- (void)movePath{
    NSString * docPath = [[NSBundle mainBundle] pathForResource:@"MSRC-iOS-1.0.0.0研发转测试发布说明" ofType:@"doc"];
    
    // 沙盒Documents目录
    //    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 沙盒Library目录
    NSString * appDir = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"路径：%@",appDir);
    //appLib  Library/Caches目录
    NSString *appLib = [appDir stringByAppendingString:@"/Documents"];
    
    BOOL filesPresent = [self copyMissingFile:docPath toPath:appLib];
    if (filesPresent) {
        NSLog(@"OK");
    }else{
        NSLog(@"NO");
    }
    
//    // 创建文件夹
//    NSString *createDir =  [NSHomeDirectory() stringByAppendingString:@"/test"];
//    [self createFolder:createDir];
//    
//    // 把文件拷贝到Test目录
//    BOOL filesPresent1 = [self copyMissingFile:docPath toPath:createDir];
//    if (filesPresent1) {
//        NSLog(@"OK");
//    }else{
//        NSLog(@"NO");
//    }
}

    /**
     *    @brief    把Resource文件夹下的save1.dat拷贝到沙盒
     *
     *    @param     sourcePath     Resource文件路径
     *    @param     toPath     把文件拷贝到XXX文件夹
     *
     *    @return    BOOL
     */
- (BOOL)copyMissingFile:(NSString *)sourcePath toPath:(NSString *)toPath
{
    BOOL retVal = YES; // If the file already exists, we'll return success…
    NSString * finalLocation = [toPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:finalLocation])
    {
        retVal = [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:finalLocation error:NULL];
    }
    return retVal;
}

/**
 *    @brief    创建文件夹
 *
 *    @param     createDir     创建文件夹路径
 */
- (void)createFolder:(NSString *)createDir
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:createDir isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:createDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
}



















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
