//
//  MRHomeViewController.h
//  MRDLNA_Example
//
//  Created by King on 2019/9/9.
//  Copyright © 2019 MQL9011. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MRHomeViewController : UIViewController

@end

@interface HomeCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *labeltext;

@end
NS_ASSUME_NONNULL_END
