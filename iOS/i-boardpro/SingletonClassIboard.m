

#import "SingletonClassIboard.h"

static SingletonClassIboard * shareSinglton;

@implementation SingletonClassIboard

+(SingletonClassIboard*)shareSinglton
{
    if (!shareSinglton) {
        shareSinglton=[[SingletonClassIboard alloc]init];
    }
    return shareSinglton;
}
- (void) shareImageToInstagramFromController:(UIViewController *) controller{
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat: @"instagram://media?id=%@",[SingletonClassIboard shareSinglton].imageId]];
   
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        
        self.documentIneraction = [UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
        self.documentIneraction.delegate = self;
        self.documentIneraction.UTI = @"com.instagram.exclusivegram";
        self.documentIneraction=[UIDocumentInteractionController interactionControllerWithURL:[NSURL URLWithString:[SingletonClassIboard shareSinglton].imagePath]];
        [self.documentIneraction setAnnotation:[NSDictionary dictionaryWithObject:[SingletonClassIboard shareSinglton].captionStr forKey:@"InstagramCaption"]];
        [self.documentIneraction presentOpenInMenuFromRect: CGRectZero    inView:controller.view animated: YES ];
        
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Alert !!!" message:@"Instagram is not present in your device" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil]show ];
    }
}



@end
