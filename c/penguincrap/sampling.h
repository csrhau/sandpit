#ifndef PENGUIN_SAMPLER_H
#define PENGUIN_SAMPLER_H

#include <stdint.h>

typedef struct reading {
    uint16_t    Asamp;          // Raw sample
    uint16_t    Vsamp;          // Raw sample
    int32_t     miliamps;       // Calculated value
    int32_t     milivolts;      // Calculated value
    int32_t     miliwatts;      // Calculated value
} reading_t;

reading_t read_channel(int channel_num);

#endif
