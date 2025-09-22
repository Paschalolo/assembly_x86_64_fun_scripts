#include <cstdio>
#include <iostream>
void convert_to_binary(char* str) {
  unsigned int* ptr = reinterpret_cast<unsigned int*>(str);
  std::printf("%.2x\t", *ptr);
}
int main() {
  char hello[] = "hello";
  convert_to_binary(hello);
}