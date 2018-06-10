#ifndef _DBTEMPLATES_H_
#define _DBTEMPLATES_H_

#include <Foundation/Foundation.h>

@interface DbTemplates : NSObject {
    NSString * configFileName;
    NSString * win32FolderName;
}

-(id) initWithConfigFileName: (NSString *) _configFileName;
-(id) initWithConfigFileName: (NSString *) _configFileName win32FolderName: (NSString*) _win32FolderName;
-(NSDictionary*) defsForKeyword: (NSString*) keyword;
-(NSString*) configFilePath;
-(NSString*) configFileContents;


@end

@interface NSString (RegexSplit)

-(NSArray*) splitWithRegex: (NSString*) regexPattern;
-(NSString*) regexReplace: (NSString*) regexPattern replacement: (NSString *) replacement;
-(NSString*) firstMatch: (NSString*) regexPattern;
-(BOOL) isEmptyOrWhitespace;

@end



#endif /* _DBTEMPLATES_H_ */
