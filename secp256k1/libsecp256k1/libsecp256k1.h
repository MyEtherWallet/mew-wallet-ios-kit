//
//  libsecp256k1.h
//  libsecp256k1
//
//  Created by Mikhail Nikanorov on 4/19/19.
//  Copyright © 2019 MyEtherWallet Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for libsecp256k1.
FOUNDATION_EXPORT double libsecp256k1VersionNumber;

//! Project version string for libsecp256k1.
FOUNDATION_EXPORT const unsigned char libsecp256k1VersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <libsecp256k1/PublicHeader.h>
#import <libsecp256k1/secp256k1.h>
#import <libsecp256k1/secp256k1_recovery.h>
#import <libsecp256k1/secp256k1_ecdh.h>
