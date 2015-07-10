//
//  UIImageView+URLImage.m
//  ImageLoad
//
//  Created by justinjing on 15/7/10.
//  Copyright (c) 2015年 justinjing. All rights reserved.
//

#import "UIImageView+URLImage.h"
#import "objc/runtime.h"


typedef void (^DownLoadProgressCallBack)(int progress,  NSError* error);
typedef void (^DownLoadDataCallBack)(NSData* data, NSError* error);

@interface ImageDownDelegate()

@property(copy) DownLoadProgressCallBack dlprogressCallback;
@property(copy) DownLoadDataCallBack completion;

@property(nonatomic) UIImageView* imageView;
@property(nonatomic) UIButton* imageButton;

@property(nonatomic,strong) NSMutableData* data;

@property(nonatomic) long long total_length;
@property(nonatomic) long long curr_length;

@end


//void get_http_data( NSString* url, void(^downLoadProgressCallBack)(int progress, NSError* error), void(^downLoadDataCallBack)(NSData* data, NSError* error))
//{
//    
//    NSMutableURLRequest* newRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
//                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
//                                                               timeoutInterval:10.0];
//    
//    ImageDownDelegate* cbk = [[ImageDownDelegate alloc] init];
//    
//    cbk.dlprogressCallback = downLoadProgressCallBack;
//    cbk.completion = downLoadDataCallBack;
//    cbk.imageButton = nil;
//    cbk.imageView = nil;
//    
//    NSURLConnection* conn = [NSURLConnection connectionWithRequest:newRequest delegate:cbk];
//    
//    [conn start];
//}



@implementation ImageDownDelegate


-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"ImageURL: Response...[%@]", response.URL.absoluteString);
    self.total_length = response.expectedContentLength;
}


-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(!self.data)
    {
        self.data = [NSMutableData dataWithData:data];
    }
    else{
        
        [self.data appendData:data];
    }
    
    self.curr_length += data.length;
    int progress = 50;
    
    if(self.total_length > 0){
        progress = (int)(self.curr_length*100 / self.total_length);
    }
    if( progress>0 && progress != 100 && self.dlprogressCallback ){
        
        self.dlprogressCallback( progress, nil);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.dlprogressCallback)
    {
        self.dlprogressCallback(100, nil);
    }
    
    if(self.completion)
    {
        
        self.completion(self.data , nil );
    }
    
    if(self.imageButton)
    {
        [self.imageButton setBackgroundImage:[UIImage imageWithData:self.data] forState:UIControlStateNormal];
    }
    else if(self.imageView)
    {
        self.imageView.image = [UIImage imageWithData:self.data];
    }
    else{
    }
 
    self.data = nil;
}


-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
 // NSLog(@"***: Read URLConnection Error");
    if(self.dlprogressCallback)
    {
        self.dlprogressCallback(-1, error);
    }
    
    if(self.completion)
    {
        self.completion( nil, error);
    }
 
    self.data= nil;
}


@end


@implementation UIImageView (URLImage)

static char sCallback;

-(ImageDownDelegate*)callback
{
    return (ImageDownDelegate*)objc_getAssociatedObject(self, &sCallback);
}

-(void)setCallback:(ImageDownDelegate *)callback
{
    objc_setAssociatedObject(self, &sCallback, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(void)setImageWithUrl:(NSString*)url placeholderImgName:(NSString*)imgName progress:(void(^)(int progress, NSError* error)) progress
{
    //如果之前有正在下载的数据，则需要移除，否则遇到重新请求网络图片的UIImageView可能出现混乱
    if(self.callback)
    {
        self.callback.imageButton = nil;
        self.callback.imageView = nil;
    }
 
	/*这里我使用扩展 NSURLProtocol 协议来缓存所有图片数据，这里的意思先判断缓存是否存在这个URL定位的图片，
          如果存在则从缓存获取图片直接显示。*/
/*    NSString* path = [SimpleURLProtocolCache getCacheFile:url];
    if(path){
        self.image = [UIImage imageWithContentsOfFile:path];
 
        return ;
    }
	*/
 
    if(imgName)
    {
      self.image = [UIImage imageNamed:imgName];
    }
    
  
    NSMutableURLRequest* newRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                              cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                          timeoutInterval:10.0];
    
    ImageDownDelegate* cbk = [[ImageDownDelegate alloc] init];
    cbk.dlprogressCallback = progress;
    cbk.completion = nil;
    cbk.imageView = self;
    cbk.imageButton = nil;
    
    self.callback = cbk;
  
    if(progress){
        
        progress(0, nil);
    }
    
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:newRequest delegate:cbk];
    [conn start];
 
}


@end

// UIBUtton
@implementation UIButton (URLImage)

-(void)setBackImageWithUrl:(NSString*)url placeholderImgName:(NSString*)imgName progress:(void(^)(int progress, NSError* error)) progress
{

    /*这里我使用扩展 NSURLProtocol 协议来缓存所有图片数据，这里的意思先判断缓存是否存在这个URL定位的图片，
          如果存在则从缓存获取图片直接显示。*/
    /*
    NSString* path = [SimpleURLProtocolCache getCacheFile:url];
    if(path){
        [self setBackgroundImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        return ;
    }*/
     if(imgName)
     {
         [self setBackgroundImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
     }
     NSMutableURLRequest* newRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                   cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                               timeoutInterval:10.0];
    
     ImageDownDelegate* cbk = [[ImageDownDelegate alloc] init];
    
    cbk.dlprogressCallback = progress;
    cbk.completion = nil;
    cbk.imageView = nil;
    cbk.imageButton = self;
    
     if(progress)
     {
         progress(0, nil);
     }
    
    NSURLConnection* conn = [NSURLConnection connectionWithRequest:newRequest delegate:cbk];
    
    [conn start];
}

@end



