//
//  Image.m
//  binzumejigoku
//
//  Created by Shizuo Ichitake on 2016/08/08.
//  Copyright © 2016年 1-Take. All rights reserved.
//

#import "ImageElement.h"
#import "NSString+CustomDecoder.h"

@interface ImageElement ()

@property (nonatomic, readwrite) UIImage*		image;
@property (nonatomic, readwrite) double			duration;
@property (nonatomic, readwrite) ImageEffect	imageEffect;

@end

@implementation ImageElement

- (id)initWithSection:(NSInteger)section sequence:(NSInteger)sequence attribute:(NSDictionary *)attrs object:(id)obj {
	if (self = [super initWithSection:section sequence:sequence attribute:attrs object:obj]) {
		_imageName = [attrs objectForKey:@"src"];
		_durationString = [attrs objectForKey:@"duration"];
		_effectString = [attrs objectForKey:@"effect"];
	}
	return self;
}

- (ContentsType)contentsType {
	return ContentsTypeImage;
}

- (NSString*)stringValue {
	return [NSString stringWithFormat:@"Image : src = %@", _imageName];
}

- (NSManagedObject*)createManagedObject:(NSFetchedResultsController*)fetchedResultsController {
	NSManagedObject* obj = [super createManagedObject:fetchedResultsController];
	
	[obj setValue:_imageName forKey:AttributeNameValue0];
	[obj setValue:_durationString forKey:AttributeNameValue1];
	[obj setValue:_effectString forKey:AttributeNameValue2];
	
	return obj;
}

@end
