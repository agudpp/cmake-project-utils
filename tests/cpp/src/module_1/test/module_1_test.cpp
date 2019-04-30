#include <gtest/gtest.h>

#include <ostream>
#include <istream>
#include <sstream>
#include <vector>

#include <module_1/test.h>

TEST(sample_test_case, sample_test)
{
    EXPECT_EQ(1, 1);
}


TEST(simple_text_element, can_add_tags)
{
  Module1 test;
  test.print();
  EXPECT_EQ(1,2);
}


int main(int argc, char **argv)
{
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
