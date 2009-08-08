//
//  Rama_BlocksAppDelegate.m
//  Rama Blocks
//
//  Created by Ryan McGarvey on 7/29/09.
//  Copyright Simplical 2009. All rights reserved.
//

#import "Rama_BlocksAppDelegate.h"
#import "GameItem.h"

@implementation Rama_BlocksAppDelegate

@synthesize window;
@synthesize gameState, boardState;



- (void)applicationDidFinishLaunching:(UIApplication *)application {
    [self loadEncodedGameState];
    [self loadEncodedBoardState];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *gameBoardFile = [NSString stringWithFormat:@"%@/gameBoardArray", documentsDirectory];
    boardState = [[NSMutableArray alloc] initWithContentsOfFile:gameBoardFile];

    
    if(boardState == nil){

        boardState = [[NSMutableArray alloc] init];
        
    }

    NSLog(@"%i", boardState.count);
    

    mainMenu = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
    [[UIApplication sharedApplication] setStatusBarHidden:YES animated:NO];
    [window addSubview:mainMenu.view];
	[window makeKeyAndVisible];
}



///////////////////////////////////////////////////////////////

-(void)saveEncodedGameState{
	NSUserDefaults *persistentStorage = [NSUserDefaults standardUserDefaults];
    NSData *encodedGameState = [NSKeyedArchiver archivedDataWithRootObject:self.gameState];
	[persistentStorage setObject:encodedGameState forKey:@"encodedGameState"];
}

-(GameState*)loadEncodedGameState{
    if (gameState == nil)
    {
        NSUserDefaults *persistentStorage = [NSUserDefaults standardUserDefaults];
        NSData *encodedGameState = [persistentStorage objectForKey: @"encodedGameState"];
        gameState = (GameState*)[NSKeyedUnarchiver unarchiveObjectWithData: encodedGameState];
    }
    return gameState;
}


////////////////////////////////////////////////////////////////



- (void)saveEncodedBoardState{
    //NSString * encodedBoardState = [self pathForDataFile];
    //[NSKeyedArchiver archiveRootObject: self.boardState toFile: encodedBoardState];
}



- (void)loadEncodedBoardState{
    //NSString * encodedBoardState = [self pathForDataFile];
    //self.boardState = [NSKeyedUnarchiver unarchiveObjectWithFile:encodedBoardState];
}





////////////////////////////////////////////////////////////////


- (void)applicationWillTerminate:(UIApplication *)application {
	[self saveEncodedGameState];
    [self saveEncodedBoardState];
    /*
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *gameBoardFile = [NSString stringWithFormat:@"%@/gameBoardArray", documentsDirectory];
    [boardState writeToFile:gameBoardFile atomically:NO];
     */
    NSLog(@"%i", boardState.count);
}



-(void)makePersistentStore{
    NSUserDefaults *gamestate = [NSUserDefaults standardUserDefaults];
	[gamestate setObject:gameState forKey:@"gamestate"];
	[gamestate synchronize];    
	
}






///////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder *)decoder{
	self = [super init];
	if( self != nil ){
        /*
		Shape * arrayThingies;
        for(arrayThingies in boardState){
            arrayThingies.shapeType = [decoder decodeIntForKey:@"encodedShapeType"];
            arrayThingies.colorType = [decoder decodeIntForKey:@"encodedColorType"];
            arrayThingies.Row = [decoder decodeIntForKey:@"encodedRow"];
            arrayThingies.Column = [decoder decodeIntForKey:@"encodedColumn"];
        }
         */
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder{
    /*
    Shape * arrayThingies;
    
    for(arrayThingies in boardState){
    [encoder encodeInt:arrayThingies.shapeType forKey:@"encodedShapeType"];
    [encoder encodeInt:arrayThingies.colorType forKey:@"encodedColorType"];
    [encoder encodeInt:arrayThingies.Row forKey:@"encodedRow"];
    [encoder encodeInt:arrayThingies.Column forKey:@"encodedColumn"];
    }
    */
}
//////////////////////////////////////////////////////////////////////


- (NSString *) pathForDataFile{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *folder = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [folder objectAtIndex:0];
    //NSString *folder = @"~/Library/Application Support/GameStuff/";
    
    NSString *gameBoardFile = [NSString stringWithFormat:@"%@/gameBoardArray", documentsDirectory];
    gameBoardFile = [gameBoardFile stringByExpandingTildeInPath];
    if ([fileManager fileExistsAtPath: gameBoardFile] == NO)
    {
        [fileManager createDirectoryAtPath: gameBoardFile attributes: nil];
    }
    
    NSString *fileName = @"rootObjectsBox";
    return [gameBoardFile stringByAppendingPathComponent: fileName];
}


/////////////////////////////////////////////////////////////////



- (void)dealloc {

	[window release];
	[super dealloc];
}


@end

