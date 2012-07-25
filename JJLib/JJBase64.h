//   |\  |\
//  _| \_| \  JJBase64.h
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import <Foundation/Foundation.h>



bool Base64Encode(const void *buffer, size_t length, char** pachOutput, size_t *outputLength, BOOL separateLines);

bool Base64Decode(const char *inputBuffer, size_t length, unsigned char** pabDecodedBytes, size_t *outputLength);
