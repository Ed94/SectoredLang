#pragma once

#include <memory>

template<typename Type>
using UPtr = std::unique_ptr<Type>;

using std::make_unique;
