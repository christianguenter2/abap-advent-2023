*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

CLASS card DEFINITION CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES:
      tt_numbers TYPE STANDARD TABLE OF i
                      WITH NON-UNIQUE DEFAULT KEY,
      BEGIN OF t_card,
        id              TYPE i,
        winning_numbers TYPE tt_numbers,
        my_numbers      TYPE tt_numbers,
      END OF t_card.

    DATA:
      attributes TYPE t_card.

    CLASS-METHODS:
      parse
        IMPORTING
          input         TYPE string
        RETURNING
          VALUE(result) TYPE REF TO card.


    METHODS:
      constructor
        IMPORTING
          i_attributes TYPE card=>t_card,

      score
        RETURNING
          VALUE(result) TYPE i,

      get_winning_numbers
        RETURNING
          VALUE(result) TYPE tt_numbers.

  PRIVATE SECTION.
    METHODS:
      is_winning
        IMPORTING
          i_number      TYPE i
        RETURNING
          VALUE(result) TYPE abap_bool,

      total
        IMPORTING
          i_r           TYPE i
        RETURNING
          VALUE(result) TYPE i.

    CLASS-METHODS:
      get_numbers
        IMPORTING
          i_numbers     TYPE string
        RETURNING
          VALUE(result) TYPE card=>tt_numbers.

ENDCLASS.
