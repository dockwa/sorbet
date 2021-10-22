#ifndef RUBY_TYPER_CRYPTO_HASHING_H
#define RUBY_TYPER_CRYPTO_HASHING_H

#include "common/common.h"
extern "C" {
#include "ref/blake2.h"
};

namespace sorbet::crypto_hashing {
inline std::array<uint8_t, 64> hash64(std::string_view data) {
    static_assert(BLAKE2B_OUTBYTES == 64);
    std::array<uint8_t, 64> res;

    int err = blake2b(&res[0], std::size(res), data.begin(), data.size(), nullptr, 0);

    ENFORCE(err == 0);
    return res;
};
} // namespace sorbet::crypto_hashing
#endif // RUBY_TYPER_CRYPTO_HASHING_H
