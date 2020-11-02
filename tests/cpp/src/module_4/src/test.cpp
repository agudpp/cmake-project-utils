#include <iostream>

#include <module_3/mod_3_test.h>
#include <module_4/mod_4_test.h>


void Module4::print()
{
    Module3 mod3;
    mod3.print();
    std::cout << "Printing module 4\n";
}