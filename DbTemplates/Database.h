#ifndef _DATABASE_H_
#define _DATABASE_H_

#include <Foundation/Foundation.h>
#include "Statement.h"

@protocol Database

-(BOOL) connect;
-(NSString*) error;
-(id <Statement>) prepare:(NSString*) query;

@end 


#endif /* _DATABASE_H_ */
