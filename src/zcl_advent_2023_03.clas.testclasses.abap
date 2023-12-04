CLASS ltcl_test DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
    DATA cut TYPE REF TO zif_advent_2023.

    METHODS setup.
    METHODS part_1 FOR TESTING.
    METHODS part_2 FOR TESTING.

ENDCLASS.


CLASS ltcl_test IMPLEMENTATION.

  METHOD setup.

    cut = NEW zcl_advent_2023_03( ).

  ENDMETHOD.

  METHOD part_1.

    DATA(part_1_result) = cut->part_1(
      VALUE #(
      ( |467..114..| )
      ( |...*......| )
      ( |..35..633.| )
      ( |......#...| )
      ( |617*......| )
      ( |.....+.58.| )
      ( |..592.....| )
      ( |......755.| )
      ( |...$.*....| )
      ( |.664.598..| )
    ) ).

    cl_abap_unit_assert=>assert_equals( act = condense( part_1_result )
                                        exp = |4361| ).

  ENDMETHOD.

  METHOD part_2.

    DATA(part_2_result) = cut->part_2(
      VALUE #(
      ( |..2*2.....| )
      ( |.......*..| )
      ( |......3.3.| )
      ( |..........| )
      ( |.....*91..| )
      ( |....9.....| )
      ( |..........| )
      ( |.....664..998...343......| )
      ( |......*............*617..| )
      ( |...407....| )
      ( |..........| )
      ( |467..114..| )
      ( |...*......| )
      ( |..35..633.| )
      ( |......#...| )
      ( |617*......| )
      ( |.....+.58.| )
      ( |..592.....| )
      ( |......755.| )
      ( |...$.*....| )
      ( |.664.598..| )
    ) ).

    cl_abap_unit_assert=>assert_equals( act = condense( part_2_result )
                                        exp = |950546| ).

  ENDMETHOD.

ENDCLASS.
