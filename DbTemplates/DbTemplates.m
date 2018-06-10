#include "DbTemplates.h"

@implementation DbTemplates

-(id) initWithConfigFileName: (NSString *) _configFileName {
    self = [super init];
    if(self) {
        configFileName = _configFileName;
        win32FolderName = _configFileName;
    }
    return self;
}

-(id) initWithConfigFileName: (NSString *) _configFileName win32FolderName: (NSString*) _win32FolderName {
    self = [super init];
    if(self) {
        configFileName = _configFileName;
        win32FolderName = _win32FolderName;
    }
    return self;
}

-(NSDictionary*) defsForKeyword: (NSString*) keyword
{
    NSString * templates = [self configFileContents];

    NSString * template_pattern = [NSString stringWithFormat:@"^(?!#)\\s*%@[^}]*", keyword];
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: template_pattern
                                                                            options: NSRegularExpressionAnchorsMatchLines
                                                                              error: NULL];
    NSMutableArray * template_declarations = [NSMutableArray array];
    for(NSTextCheckingResult * match in [regex matchesInString:templates
                                                     options:0
                                                       range:NSMakeRange(0, [templates length])])
    {
        NSRange matchRange = [match range];
        [template_declarations addObject: [templates substringWithRange: matchRange]];
    }

    regex = [NSRegularExpression regularExpressionWithPattern: [NSString stringWithFormat:@"(?<=%@)\\s+([^\\s\\\"]+|\\\".*\\\")", 
                                                                                keyword]
                                                      options: 0
                                                        error: NULL];

    NSMutableDictionary * dict = [NSMutableDictionary dictionary];

    for(NSString * template in template_declarations)
    {
        NSString * template_name = [template substringWithRange: [regex rangeOfFirstMatchInString: template
                                                                                           options: 0
                                                                                             range: NSMakeRange(0, [template length])]];
        //trim                                                                                            
        template_name = [template_name stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

        //remove quotes
        template_name = [template_name stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"\""]];


        NSRange start = [template rangeOfString:@"{"];
        if(start.location == NSNotFound) {
            return nil;
        }
        NSString * defs = [template substringFromIndex: start.location+1];
        NSArray * lines = [defs splitWithRegex:@"(?<!\\\\)[\\\n|\\\r|\\\r\\\n|\\\n\\\r]"];

        NSMutableDictionary * value_dict = [NSMutableDictionary dictionary];

        for(NSString * line in lines) {
            //remove backslashes/newlines
            line = [line regexReplace:@"\\s*\\\\[\\\r\\\n|\\\n\\\r|\\\n|\\\r]\\s*" replacement: @""];
            //trim
            line = [line stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];

            NSString * key = [line firstMatch:@"^\\w+"];
            if([key isEmptyOrWhitespace])
                continue;

            NSString * value = [line firstMatch:[NSString stringWithFormat:@"(?<=%@).*?(?=[^\\\\]#|$)", key]];
                                                       
            value = [value regexReplace:@"\\\\#" replacement:@"#"];
            value = [value stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [value_dict setObject: value forKey: key];
        }
        [dict setObject: value_dict forKey: template_name];
    }
    return dict;
}

-(NSString*) configFileContents {
    return [NSString stringWithContentsOfFile:[self configFilePath]
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
}


-(NSString*) configFilePath {
    NSProcessInfo * pi = [NSProcessInfo processInfo];
    if(win32FolderName == nil)
        win32FolderName = configFileName;

    if([pi operatingSystem] == NSWindowsNTOperatingSystem) {
        //config file in Windows
        NSDictionary * env = [pi environment];
        NSString * appdata = [env objectForKey:@"APPDATA"];
        NSString * appdir = [appdata stringByAppendingPathComponent: win32FolderName];
        return [appdir stringByAppendingPathComponent: configFileName];
    } else {
        //config file in good OSes
        NSString * homeDir = NSHomeDirectory();
        return [homeDir stringByAppendingPathComponent: [NSString stringWithFormat:@".%@", configFileName]];
    }
}

@end



@implementation NSString (RegexSplit)

-(NSArray*) splitWithRegex: (NSString*) regexPattern {
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: regexPattern options:0 error: NULL];
    int start = 0;
    NSMutableArray * matches = [NSMutableArray array];
    for(NSTextCheckingResult * match in [regex matchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, [self length])])
    {
        NSRange matchRange = [match range];
        //NSLog(@"start: %d, location: %d", start, matchRange.location);
        [matches addObject: [self substringWithRange:NSMakeRange(start, matchRange.location  - start)]];
        start = matchRange.location + matchRange.length;
    }
    [matches addObject: [self substringFromIndex: start]];
    return matches;
}

-(NSString*) regexReplace: (NSString*) regexPattern replacement: (NSString *) replacement {
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: regexPattern options: 0 error: NULL];
    return [regex stringByReplacingMatchesInString: self 
                                           options: 0
                                             range: NSMakeRange(0, [self length])
                                      withTemplate: replacement];
}

-(NSString*) firstMatch: (NSString*) regexPattern {
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern: regexPattern options: 0 error: NULL];
    NSTextCheckingResult * match = [regex firstMatchInString: self options: 0 range: NSMakeRange(0, [self length])];
    NSRange range = [match range];
    return range.location == NSNotFound ? nil : [self substringWithRange:range];
}

-(BOOL) isEmptyOrWhitespace {
    return [[self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]] length] == 0;
}



@end
