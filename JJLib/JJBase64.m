//   |\  |\
//  _| \_| \  JJBase64.m
// / |  \|  \
// \ |  /|  / JJLib  Copyright (c) 2007-2012  Ian Gordon
//  \__/\__/



#import "JJBase64.h"



// 3 Binary bytes <> 4 Base64 characters
static const size_t BINARY_UNIT_SIZE = 3;
static const size_t BASE64_UNIT_SIZE = 4;


static char BASE64_ENCODING_TABLE[] = 
{
	'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P',
	'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
	'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
	'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'
};


const unsigned char XX = 0xff;
static const unsigned char BASE64_DECODING_TABLE[] =
{
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 62, XX, XX, XX, 63, 
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, XX, XX, XX, XX, XX, XX, 
    XX,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, XX, XX, XX, XX, XX, 
    XX, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, 
    XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX, XX
};


//
// NewBase64Encode
//
// Encodes the arbitrary data in the inputBuffer as base64 into a newly malloced
// output buffer.
//
//  inputBuffer - the source data for the encode
//	length - the length of the input in bytes
//  separateLines - if zero, no CR/LF characters will be added. Otherwise
//		a CR/LF pair will be added every 64 encoded chars.
//	outputLength - if not-NULL, on output will contain the encoded length
//		(not including terminating 0 char)
//
// returns the encoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
bool Base64Encode(const void *buffer, size_t length, char** pachOutput, size_t *outputLength, BOOL separateLines)
{
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
    const size_t OUTPUT_LINE_LENGTH = 64;
    const size_t INPUT_LINE_LENGTH = ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE);
    const size_t CR_LF_SIZE = 2;
	
	//
	// Byte accurate calculation of final buffer size
	//
	size_t outputBufferSize = ( (length / BINARY_UNIT_SIZE) + ((length % BINARY_UNIT_SIZE) ? 1 : 0) ) * BASE64_UNIT_SIZE;
	if (separateLines)
	{
		outputBufferSize +=	(outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
	
	//
	// Include space for a terminating zero
	//
	outputBufferSize += 1;
	
	
	// If the user has not included destination buffer end now.  Note that the outputLength will be accurate.
	if (NULL == pachOutput)
	{
		return false;
	}
	
	
	//
	// Allocate the output buffer
	//
	//	char *outputBuffer = (char *)malloc(outputBufferSize);
	
	char* outputBuffer = malloc(outputBufferSize * sizeof(char) );
	if (!outputBuffer)
	{
		return false;
	}
	
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
	
	while (true)
	{
		if (lineEnd > length)
		{
			lineEnd = length;
		}
		
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
		{
			//
			// Inner loop: turn 48 bytes into 64 base64 characters
			//
			outputBuffer[j++] = BASE64_ENCODING_TABLE[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = BASE64_ENCODING_TABLE[((inputBuffer[i] & 0x03) << 4)
													  | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = BASE64_ENCODING_TABLE[((inputBuffer[i + 1] & 0x0F) << 2)
													  | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = BASE64_ENCODING_TABLE[inputBuffer[i + 2] & 0x3F];
		}
		
		if (lineEnd == length)
		{
			break;
		}
		
		//
		// Add the newline
		//
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
	
	if (i + 1 < length)
	{
		//
		// Handle the single '=' case
		//
		outputBuffer[j++] = BASE64_ENCODING_TABLE[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = BASE64_ENCODING_TABLE[((inputBuffer[i] & 0x03) << 4)
												  | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = BASE64_ENCODING_TABLE[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	}
	else if (i < length)
	{
		//
		// Handle the double '=' case
		//
		outputBuffer[j++] = BASE64_ENCODING_TABLE[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = BASE64_ENCODING_TABLE[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
	
	//
	// Set the output length and return the buffer
	//
	if (outputLength)
	{
		*outputLength = j;
	}
	
	*pachOutput = outputBuffer;
	
	return true;
}






//
// NewBase64Decode
//
// Decodes the base64 ASCII string in the inputBuffer to a newly malloced
// output buffer.
//
//  inputBuffer - the source ASCII string for the decode
//	length - the length of the string or -1 (to specify strlen should be used)
//	outputLength - if not-NULL, on output will contain the decoded length
//
// returns the decoded buffer. Must be free'd by caller. Length is given by
//	outputLength.
//
bool Base64Decode(const char *inputBuffer, size_t length, unsigned char** pabDecodedBytes, size_t *outputLength)
{
	size_t outputBufferSize = (length / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE;
	
	if (NULL == pabDecodedBytes)
	{
		return false;
	}
	
	unsigned char* outputBuffer = (unsigned char *)malloc(outputBufferSize);
	
	size_t i = 0;
	size_t j = 0;
	while (i < length)
	{
		//
		// Accumulate 4 valid characters (ignore everything else)
		//
		unsigned char accumulated[BASE64_UNIT_SIZE];
		size_t accumulateIndex = 0;
		while (i < length)
		{
			int iInputBuffer = inputBuffer[i++];
			unsigned char decode = BASE64_DECODING_TABLE[iInputBuffer];
			if (decode != XX)
			{
				accumulated[accumulateIndex] = decode;
				accumulateIndex++;
				
				if (BASE64_UNIT_SIZE == accumulateIndex)
				{
					break;
				}
			}
		}
		
		//
		// Store the 6 bits from each of the 4 characters as 3 bytes
		//
		outputBuffer[j] = (accumulated[0] << 2) | (accumulated[1] >> 4);
		outputBuffer[j + 1] = (accumulated[1] << 4) | (accumulated[2] >> 2);
		outputBuffer[j + 2] = (accumulated[2] << 6) | accumulated[3];
		j += accumulateIndex - 1;
	}
	
	if (outputLength)
	{
		*outputLength = j;
	}
	
	*pabDecodedBytes = outputBuffer;
	
	return true;
}




