//
//  AppDelegate.h
//  VideoPlyay
//
//  Created by TianQin on 2019/7/18.
//  Copyright © 2019 TianQin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

