#ifndef _DATABASEFACTORY_H_
#define _DATABASEFACTORY_H_

#include <Foundation/Foundation.h>
#include "Database.h"

@interface DatabaseFactory : NSObject

+(id <Database>) databaseWithTemplateName: (NSString*) templateName;
+(id <Database>) databaseWithTemplate:(NSDictionary*) template;

@end 


#endif /* _DATABASEFACTORY_H_ */
