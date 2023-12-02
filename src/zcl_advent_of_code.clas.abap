CLASS zcl_advent_of_code DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_http_service_extension .

ENDCLASS.



CLASS zcl_advent_of_code IMPLEMENTATION.

  METHOD if_http_service_extension~handle_request.

    DATA(lv_resp) = SWITCH string( request->get_method( )
       WHEN 'GET'  THEN z2ui5_cl_fw_http_handler=>http_get( )
       WHEN 'POST' THEN z2ui5_cl_fw_http_handler=>http_post( request->get_text( ) ) ).

    response->set_header_field( i_name = `cache-control` i_value = `no-cache` ).
    response->set_text( lv_resp ).
    response->set_status( 200 ).

  ENDMETHOD.

ENDCLASS.
