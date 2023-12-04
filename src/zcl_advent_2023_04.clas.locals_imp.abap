*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS card IMPLEMENTATION.

  METHOD constructor.

    me->attributes = i_attributes.

  ENDMETHOD.

  METHOD parse.

    DATA: card TYPE card=>t_card.

    card-id = EXACT i( match( val = input pcre = `(\d+)` ) ).

    SPLIT substring_after( val = input sub = ':' ) AT `|` INTO DATA(winning_numbers) DATA(my_numbers).

    card-winning_numbers = get_numbers( winning_numbers ).
    card-my_numbers = get_numbers( my_numbers ).

    result = NEW #( card ).

  ENDMETHOD.


  METHOD get_numbers.

    FIND
      ALL OCCURRENCES OF PCRE `(\d+)`
      IN i_numbers
      RESULTS DATA(results).

    result = VALUE #(
               FOR r IN results
               ( CONV i( substring( val = i_numbers off = r-offset len = r-length ) ) ) ).

  ENDMETHOD.


  METHOD score.

    result = REDUCE i(
               INIT r = 0
               FOR <w> IN attributes-winning_numbers
               NEXT r = COND i(
                          WHEN is_winning( <w> )
                          THEN total( r )
                          ELSE r ) ).

  ENDMETHOD.


  METHOD is_winning.

    result = xsdbool( line_exists( attributes-my_numbers[ table_line = i_number ] ) ).

  ENDMETHOD.


  METHOD total.

    result = COND i(
               WHEN i_r IS INITIAL
               THEN 1
               ELSE i_r * 2 ).

  ENDMETHOD.


  METHOD get_winning_numbers.

    result = VALUE #(
               FOR <w> IN attributes-winning_numbers
               ( COND #( WHEN is_winning( <w> ) THEN <w> ) ) ).

    DELETE result WHERE table_line IS INITIAL.

  ENDMETHOD.

ENDCLASS.
