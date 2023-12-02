CLASS zcl_advent_2023_02 DEFINITION
  PUBLIC
  INHERITING FROM zcl_advent_2023_main
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS part_1 REDEFINITION.
    METHODS part_2 REDEFINITION.

  PROTECTED SECTION.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF t_subset,
        count TYPE i,
        color TYPE c LENGTH 10,
      END OF t_subset,
      tt_subset TYPE STANDARD TABLE OF t_subset
                     WITH NON-UNIQUE DEFAULT KEY,
      BEGIN OF t_game,
        id     TYPE i,
        subset TYPE tt_subset,
      END OF t_game,
      tt_games TYPE STANDARD TABLE OF t_game
                    WITH NON-UNIQUE DEFAULT KEY.

    METHODS:
      is_impossible
        IMPORTING
          i_game        TYPE t_game
        RETURNING
          VALUE(result) TYPE abap_boolean,

      parse_input
        IMPORTING
          i_input       TYPE zif_advent_2023=>ty_input_table
        RETURNING
          VALUE(result) TYPE zcl_advent_2023_02=>tt_games,

      get_power
        IMPORTING
          i_game        TYPE t_game
        RETURNING
          VALUE(result) TYPE i,

      get_subsets
        IMPORTING
          i_line        TYPE string
        RETURNING
          VALUE(result) TYPE zcl_advent_2023_02=>tt_subset.

ENDCLASS.



CLASS zcl_advent_2023_02 IMPLEMENTATION.

  METHOD part_1.

    result = REDUCE #(
               INIT r = 0
               FOR g IN parse_input( input )
               NEXT r = r + COND #(
                              WHEN is_impossible( g ) = abap_false
                              THEN g-id ) ).

  ENDMETHOD.


  METHOD part_2.

    result = REDUCE #(
               INIT r = 0
               FOR g IN parse_input( input )
               NEXT r = r + get_power( g ) ).

  ENDMETHOD.


  METHOD is_impossible.

    LOOP AT i_game-subset ASSIGNING FIELD-SYMBOL(<s>).

      result = COND #(
                 WHEN <s>-color = 'red'   AND <s>-count > 12 THEN abap_true
                 WHEN <s>-color = 'green' AND <s>-count > 13 THEN abap_true
                 WHEN <s>-color = 'blue'  AND <s>-count > 14 THEN abap_true
                 ELSE result
              ).

    ENDLOOP.

  ENDMETHOD.


  METHOD parse_input.

    result = VALUE #(
               FOR <line> IN i_input (
                 id     = CONV i( match( val = <line> pcre = `\d+` ) )
                 subset = get_subsets( <line> )
               ) ).

  ENDMETHOD.


  METHOD get_power.

    SELECT
      FROM @i_game-subset AS s
      FIELDS
        color AS color,
        MAX( count ) AS max
      GROUP BY (  color )
      INTO TABLE @DATA(min_config) ##ITAB_KEY_IN_SELECT ##ITAB_DB_SELECT .

    result = min_config[ color = 'red' ]-max
           * min_config[ color = 'blue' ]-max
           * min_config[ color = 'green' ]-max.

  ENDMETHOD.


  METHOD get_subsets.

    FIND
      ALL OCCURRENCES OF PCRE `(?<count>\d+)\s(?<color>red|blue|green)[,;]?`
      IN i_line
      RESULTS DATA(results).

    result = VALUE #(
               FOR <result> IN results
               LET s_count = <result>-submatches[ 1 ]
                   s_color = <result>-submatches[ 2 ]
               IN (
                 count = CONV i( substring( val = i_line off = s_count-offset len = s_count-length ) )
                 color =         substring( val = i_line off = s_color-offset len = s_color-length )
               ) ).

  ENDMETHOD.

ENDCLASS.
