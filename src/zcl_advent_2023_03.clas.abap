CLASS zcl_advent_2023_03 DEFINITION
  PUBLIC
  INHERITING FROM zcl_advent_2023_main
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    METHODS part_1 REDEFINITION.
    METHODS part_2 REDEFINITION.

  PROTECTED SECTION.
  PRIVATE SECTION.
    METHODS get_sum_of_parts
      IMPORTING !input        TYPE zif_advent_2023=>ty_input_table
                !symbols      TYPE match_result_tab
                numbers       TYPE match_result_tab
      RETURNING VALUE(result) TYPE i.

    METHODS get_sum_of_gear_ratios
      IMPORTING !input        TYPE zif_advent_2023=>ty_input_table
                !symbols      TYPE match_result_tab
                numbers       TYPE match_result_tab
      RETURNING VALUE(result) TYPE i.

    METHODS get_symbols
      IMPORTING !input        TYPE zif_advent_2023=>ty_input_table
                !pcre         TYPE string
      RETURNING VALUE(result) TYPE match_result_tab.

    METHODS get_numbers
      IMPORTING !input        TYPE zif_advent_2023=>ty_input_table
      RETURNING VALUE(result) TYPE match_result_tab.

    METHODS is_adjacent
      IMPORTING token_1       TYPE match_result
                token_2       TYPE match_result
      RETURNING VALUE(result) TYPE abap_bool.

ENDCLASS.



CLASS zcl_advent_2023_03 IMPLEMENTATION.


  METHOD part_1.

    result = get_sum_of_parts(
                 input   = input
                 symbols = get_symbols( input = input pcre = `(\*|\#|\+|\-|\$|\%|\@|\=|\\|\/|\&)` )
                 numbers = get_numbers( input ) ).

  ENDMETHOD.


  METHOD part_2.

    result = get_sum_of_gear_ratios(
                 input   = input
                 symbols = get_symbols( input = input pcre = `(\*)` )
                 numbers = get_numbers( input ) ).

  ENDMETHOD.


  METHOD get_sum_of_gear_ratios.

    TYPES:
      BEGIN OF t_vector,
        n  LIKE LINE OF numbers,
        n2 LIKE LINE OF numbers,
      END OF t_vector,
      tt_vector TYPE STANDARD TABLE OF t_vector
                     WITH NON-UNIQUE DEFAULT KEY.

    DATA: vector TYPE tt_vector.

    DATA found TYPE abap_bool.

    LOOP AT numbers ASSIGNING FIELD-SYMBOL(<n>).

      DATA(n) = CONV i( substring( val = input[ <n>-line ]
                                   off = <n>-offset
                                   len = <n>-length ) ).

      CLEAR found.

      LOOP AT symbols ASSIGNING FIELD-SYMBOL(<s>).

        IF is_adjacent(
             token_1 = <n>
             token_2 = <s> ).

          LOOP AT numbers ASSIGNING FIELD-SYMBOL(<n2>).

            CHECK <n> <> <n2>.

            IF is_adjacent(
                 token_1 = <s>
                 token_2 = <n2> ).

              DATA(n2) = CONV i( substring( val = input[ <n2>-line ]
                                            off = <n2>-offset
                                            len = <n2>-length ) ).

              found = abap_true.
              EXIT.

            ENDIF.

          ENDLOOP.

        ENDIF.

        IF found = abap_true.
          EXIT.
        ENDIF.

      ENDLOOP.

      IF found = abap_true
      AND NOT line_exists( vector[ n = <n>  n2 = <n2> ] )
      AND NOT line_exists( vector[ n = <n2> n2 = <n> ] ).

        INSERT
          VALUE #(
            n  = <n>
            n2 = <n2> )
          INTO TABLE vector.

        result += n * n2.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_symbols.

    FIND
      ALL OCCURRENCES OF PCRE pcre
      IN TABLE input
      RESULTS result.

  ENDMETHOD.


  METHOD get_numbers.

    FIND
      ALL OCCURRENCES OF PCRE `(\d+)`
      IN TABLE input
      RESULTS result.

  ENDMETHOD.


  METHOD get_sum_of_parts.

    DATA found TYPE abap_bool.

    LOOP AT numbers ASSIGNING FIELD-SYMBOL(<n>).

      DATA(n) = CONV i( substring( val = input[ <n>-line ]
                                   off = <n>-offset
                                   len = <n>-length ) ).

      CLEAR found.

      LOOP AT symbols ASSIGNING FIELD-SYMBOL(<s>).

        IF is_adjacent( token_1 = <n>
                        token_2 = <s> ).
          found = abap_true.
          EXIT.
        ENDIF.

      ENDLOOP.

      IF found = abap_true.
        result += n.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD is_adjacent.

    result = xsdbool(     (    token_1-line   = token_2-line
                            OR token_1-line   = token_2-line + 1
                            OR token_1-line   = token_2-line - 1 )
                           AND token_1-offset + token_1-length >= token_2-offset
                           AND token_1-offset <= token_2-offset + token_2-length ).

  ENDMETHOD.
ENDCLASS.
