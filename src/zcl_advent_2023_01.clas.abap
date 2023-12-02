CLASS zcl_advent_2023_01 DEFINITION
  PUBLIC
  INHERITING FROM zcl_advent_2023_main
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS part_1 REDEFINITION.
    METHODS part_2 REDEFINITION.


  PRIVATE SECTION.
    TYPES:
      t_255 TYPE c LENGTH 255,
      BEGIN OF t_input,
        line    TYPE t_255,
        reverse TYPE t_255,
      END OF t_input,
      tt_input TYPE STANDARD TABLE OF t_input
                    WITH NON-UNIQUE DEFAULT KEY.

    METHODS:
      convert_input
        IMPORTING
          i_input       TYPE zif_advent_2023=>ty_input_table
        RETURNING
          VALUE(result) TYPE tt_input,

      get_sum_of_all_cal_values
        IMPORTING
          input         TYPE tt_input
          regex         TYPE t_255
          reverse_regex TYPE t_255
        RETURNING
          VALUE(result) TYPE string.

ENDCLASS.



CLASS zcl_advent_2023_01 IMPLEMENTATION.

  METHOD part_1.

    result = get_sum_of_all_cal_values(
                 input         = convert_input( input )
                 regex         = '(\d)'
                 reverse_regex = '(\d)' ).

  ENDMETHOD.


  METHOD part_2.

    result = get_sum_of_all_cal_values(
               input         = convert_input( input )
               regex         = `(\d|one|two|three|four|five|six|seven|eight|nine)`
               reverse_regex = `(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)` ).

  ENDMETHOD.


  METHOD convert_input.

    result = VALUE tt_input(
               FOR line IN i_input
               ( line    = line
                 reverse = reverse( line ) ) ).

  ENDMETHOD.


  METHOD get_sum_of_all_cal_values.

    SELECT
      FROM @input AS i
      FIELDS
        CAST(
          SUM(
            CAST(
              concat(
                CASE substring_regexpr(
                      pcre  = @regex ,
                      value = i~line )
                  WHEN 'one'   THEN '1'
                  WHEN 'two'   THEN '2'
                  WHEN 'three' THEN '3'
                  WHEN 'four'  THEN '4'
                  WHEN 'five'  THEN '5'
                  WHEN 'six'   THEN '6'
                  WHEN 'seven' THEN '7'
                  WHEN 'eight' THEN '8'
                  WHEN 'nine'  THEN '9'
                  ELSE CAST(
                    substring_regexpr(
                      pcre  = @regex ,
                      value = i~line ) AS CHAR( 1 ) )
                END,
                CASE substring_regexpr(
                      pcre  = @reverse_regex,
                      value = i~reverse )
                  WHEN @( CONV t_255( reverse( 'one' ) ) )   THEN '1'
                  WHEN @( CONV t_255( reverse( 'two' ) ) )   THEN '2'
                  WHEN @( CONV t_255( reverse( 'three' ) ) ) THEN '3'
                  WHEN @( CONV t_255( reverse( 'four' ) ) )  THEN '4'
                  WHEN @( CONV t_255( reverse( 'five' ) ) )  THEN '5'
                  WHEN @( CONV t_255( reverse( 'six' ) ) )   THEN '6'
                  WHEN @( CONV t_255( reverse( 'seven' ) ) ) THEN '7'
                  WHEN @( CONV t_255( reverse( 'eight' ) ) ) THEN '8'
                  WHEN @( CONV t_255( reverse( 'nine' ) ) )  THEN '9'
                  ELSE CAST(
                    substring_regexpr(
                      pcre  = @reverse_regex,
                      value = i~reverse ) AS CHAR( 1 ) )
                END )
              AS INT4 ) )
            AS SSTRING )
          AS sum
      INTO @result ##ITAB_KEY_IN_SELECT ##ITAB_DB_SELECT .

  ENDMETHOD.

ENDCLASS.
