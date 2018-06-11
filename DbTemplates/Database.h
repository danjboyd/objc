#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <Foundation/Foundation.h>

@protocol Database

-(id) initWithDsn:(NSString*) _dsn username: (NSString*) _username password: (NSString*) _password;
-(BOOL) connect;
-(NSString*) error;
-(id) prepare:(NSString*) query;

@end 


#endif /* _DATABASE_H_ */
