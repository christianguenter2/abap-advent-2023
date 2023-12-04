CLASS zcl_advent_2023_04 DEFINITION
  PUBLIC
  INHERITING FROM zcl_advent_2023_main
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS part_1 REDEFINITION.
    METHODS part_2 REDEFINITION.

    INTERFACES:
      if_oo_adt_classrun.

    CLASS-DATA out TYPE REF TO if_oo_adt_classrun_out.

  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF t_card,
        id   TYPE i,
        card TYPE REF TO card,
      END OF t_card,
      tt_cards TYPE SORTED TABLE OF t_card
                    WITH NON-UNIQUE KEY id.

    METHODS:
      parse_input
        IMPORTING
          input         TYPE zif_advent_2023=>ty_input_table
        RETURNING
          VALUE(result) TYPE tt_cards.

ENDCLASS.



CLASS zcl_advent_2023_04 IMPLEMENTATION.

  METHOD part_1.

    result = REDUCE #(
               INIT r = 0
               FOR card IN parse_input( input )
               NEXT r = r + card-card->score( ) ).

  ENDMETHOD.


  METHOD part_2.

    DATA(cards) = parse_input( input ).

    LOOP AT cards ASSIGNING FIELD-SYMBOL(<c>).

      DATA(winners) = <c>-card->get_winning_numbers( ).

      LOOP AT winners ASSIGNING FIELD-SYMBOL(<w>).

        TRY.
            INSERT cards[ id = <c>-id + sy-tabix ] INTO TABLE cards.

          CATCH cx_sy_itab_line_not_found.
        ENDTRY.

      ENDLOOP.

    ENDLOOP.

    result = lines( cards ).

  ENDMETHOD.


  METHOD parse_input.

    result = VALUE #(
               FOR i IN input
               LET c = card=>parse( i )
               IN ( id   = c->attributes-id
                    card = c ) ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    FINAL(cut) = NEW zcl_advent_2023_04( ).

    cut->out = out.

    DATA(part_1_result) = cut->part_1(
      VALUE #(
      ( |Card 1: 41 48 83 86 17 \| 83 86  6 31 17  9 48 53| )
      ( |Card 2: 13 32 20 16 61 \| 61 30 68 82 17 32 24 19| )
      ( |Card 3:  1 21 53 59 44 \| 69 82 63 72 16 21 14  1| )
      ( |Card 4: 41 92 73 84 69 \| 59 84 76 51 58  5 54 83| )
      ( |Card 5: 87 83 26 28 32 \| 88 30 70 12 93 22 82 36| )
      ( |Card 6: 31 18 13 56 72 \| 74 77 10 23 35 67 36 11| )
    ) ).

  ENDMETHOD.

ENDCLASS.
