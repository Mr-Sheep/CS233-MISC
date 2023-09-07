/**
 * @file
 * Contains an implementation of the extractMessage function.
 */
#include "extractMessage.h"
#include <assert.h>
#include <iostream> // might be useful for debugging

using namespace std;

unsigned char *extractMessage(const unsigned char *message_in, int length) {
  // length must be a multiple of 8
  assert((length % 8) == 0);

  // allocate an array for the output
  unsigned char *message_out = new unsigned char[length];
  for (int i = 0; i < length; i++) {
    message_out[i] = 0;
  }

  // TODO: write your code here

  // i'll just put this here that im an idiot cuz i made this to encode the
  // message instead of extracting it...

  // (7 - j, 7 - i) => (i, j)
  for (int k = 0; k < length; k += 8) {
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        gettting the bit unsigned char mask =
            1 << i; // shift the mask to the current
        location unsigned char curr =
            (message_in[k + 7 - j] & mask) >>
            i; // get the bit at curr_loc, move it all the wya to the end

        // replcing the target
        // unsigned char dummy_mask = ~(1 << (7 - j));
        // unsigned char new_bit = curr << (7 - j);
        // message_out[k + i] &= dummy_mask;
        // message_out[k + i] |= new_bit;

        unsigned chat temp = message_out[k + i] & 0x01;
        message_out >>= 1;
        message_out[k + j] |= (message_out[k + i] << i);
      }
    }
  }

  // for (int i = 7; i >= 0; i--) {
  //   unsigned char row = message_in[i];
  //   for (int j = 7; j >= 0; j--) {
  //     unsigned char tmp = row & 0x00000001;
  //     row >>= 1;
  //     message_out[7 - j] |= tmp;
  //     message_out[7 - j] <<= 1;
  //   }
  // }

  return message_out;
}

// Knock