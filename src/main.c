#include <stdio.h>
#include <unistd.h>
#include <immintrin.h>
#define true 1
#define false 0
inline void maskop(unsigned char *bufff, __m256i v_A_minus_1, __m256i v_Z_plus_1, __m256i v_32)
{
    // 1. Load 32 bytes of data (from bufff[0] or bufff[32])
    // We use an "aligned" load since we used alignas(32)
    __m256i data = _mm256_load_si256((__m256i *)(bufff));

    // 2. Create masks by comparing all 32 bytes
    // AVX2 doesn't have >= or <= for 8-bit, so we use >
    // (c >= 'A') is the same as (c > 'A'-1)
    // (c <= 'Z') is the same as ('Z'+1 > c)

    // mask_ge_A will be 0xFF where data[i] >= 'A', 0x00 otherwise
    __m256i mask_ge_A = _mm256_cmpgt_epi8(data, v_A_minus_1);

    // mask_le_Z will be 0xFF where data[i] <= 'Z', 0x00 otherwise
    __m256i mask_le_Z = _mm256_cmpgt_epi8(v_Z_plus_1, data);

    // 3. Combine masks: (c >= 'A' AND c <= 'Z')
    // This gives 0xFF for uppercase bytes, 0x00 for all others
    __m256i mask_is_upper = _mm256_and_si256(mask_ge_A, mask_le_Z);

    // 4. Calculate the lowercase version (subtract 32)
    __m256i data_lower = _mm256_sub_epi8(data, v_32);

    // 5. Blend the results (The "if" statement)
    // For each byte:
    //   if (mask_is_upper[i] is 0xFF) -> use data_lower[i]
    //   if (mask_is_upper[i] is 0x00) -> use data[i]
    __m256i result = _mm256_blendv_epi8(data, data_lower, mask_is_upper);

    // 6. Store the 32-byte result back into the buffer
    _mm256_store_si256((__m256i *)(bufff), result);
}
int convert()
{

    unsigned char bufff[640] __attribute__((aligned(32)));
    ssize_t value;
    ssize_t errWr;

    // We create 32-byte ('A', 'A', 'A', ...) vectors
    const __m256i v_A_minus_1 = _mm256_set1_epi8('a' - 1);
    const __m256i v_Z_plus_1 = _mm256_set1_epi8('z' + 1);
    // The value to add to 'A' to get 'a'
    const __m256i v_32 = _mm256_set1_epi8('a' - 'A');
    size_t count = 0;
    unsigned char *buffey = bufff;
    value = read(0, bufff, 640);
    do
    {
        if (count >= 4)
        {
            errWr = write(1, (void *)bufff, value);
            value = read(0, bufff, 640);
            count = 0;
            buffey = bufff;
        }

        maskop(buffey, v_A_minus_1, v_Z_plus_1, v_32);
        maskop(buffey + 32, v_A_minus_1, v_Z_plus_1, v_32);
        maskop(buffey + 64, v_A_minus_1, v_Z_plus_1, v_32);
        maskop(buffey + 96, v_A_minus_1, v_Z_plus_1, v_32);
        maskop(buffey + 128, v_A_minus_1, v_Z_plus_1, v_32);
        buffey += 160;

        ++count;

    } while (value > 0);

    if (value == -1 || errWr == -1)
        return -1;
    return 0;
}

int main()
{
    convert();
    // ifwrite(1, "Hello", 5);
    return 0;
}

// if (value < 96)
// {
//     size_t conunt_left;
//     if (value >= 64)
//     {
//         value -= 64;
//         maskop(bufff, v_A_minus_1, v_Z_plus_1, v_32);
//         maskop(bufff + 32, v_A_minus_1, v_Z_plus_1, v_32);
//     }
//     for (size_t i = 0; i < value; i++)
//     {
//         if (bufff +)
//     }
// }