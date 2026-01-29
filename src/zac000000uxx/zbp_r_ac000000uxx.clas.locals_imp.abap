CLASS lhc_zr_ac000000uxx DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR ShoppingCart
        RESULT result,
      setStatusToNew FOR DETERMINE ON MODIFY
        IMPORTING keys FOR ShoppingCart~setStatusToNew.

    METHODS calculateOrderID FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~calculateOrderID.

    METHODS setStatusToSaved FOR DETERMINE ON SAVE
      IMPORTING keys FOR ShoppingCart~setStatusToSaved.
    METHODS validateOrderedItem FOR VALIDATE ON SAVE
      IMPORTING keys FOR ShoppingCart~validateOrderedItem.

    METHODS validateOrderQuantity FOR VALIDATE ON SAVE
      IMPORTING keys FOR ShoppingCart~validateOrderQuantity.

    METHODS validateRequestedDeliveryDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ShoppingCart~validateRequestedDeliveryDate.
ENDCLASS.

CLASS lhc_zr_ac000000uxx IMPLEMENTATION.
  METHOD get_global_authorizations.
    DATA(a) = 1.
  ENDMETHOD.
  METHOD setStatusToNew.

    DATA update TYPE TABLE FOR UPDATE zr_AC000000UXX\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_AC000000UXX\\ShoppingCart .

    "Read entity instances of the transferred keys
    READ ENTITIES OF zr_AC000000UXX IN LOCAL MODE
        ENTITY ShoppingCart
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    "retrieve all instances where the overallstatus is not yet set
    "and set the initial value to 'new'
    LOOP AT entities INTO DATA(entity) WHERE OverallStatus IS INITIAL.
      update_line-%tky    = entity-%tky.
      update_line-OverallStatus = zbp_r_AC000000UXX=>order_state-new.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_AC000000UXX IN LOCAL MODE
      ENTITY ShoppingCart
        UPDATE FIELDS ( OverallStatus )
          WITH update
     REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.



  METHOD calculateOrderID.

    DATA update TYPE TABLE FOR UPDATE zr_AC000000UXX\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_AC000000UXX\\ShoppingCart .

    READ ENTITIES OF zr_AC000000UXX IN LOCAL MODE
        ENTITY ShoppingCart
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).

    DELETE entities WHERE orderID IS NOT INITIAL.
    CHECK entities IS NOT INITIAL.

    "Poor man's approach to determine object_id ;-)

    SELECT MAX( order_ID ) FROM zAC000000UXX INTO @DATA(max_object_id).

    LOOP AT entities INTO DATA(entity).
      update_line-%tky    = entity-%tky.
      update_line-orderid = max_object_id + 1.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_AC000000UXX IN LOCAL MODE
      ENTITY ShoppingCart
        UPDATE FIELDS ( orderID )
          WITH update
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.
  METHOD setStatusToSaved.
    DATA update TYPE TABLE FOR UPDATE zr_AC000000UXX\\ShoppingCart.
    DATA update_line TYPE STRUCTURE FOR UPDATE zr_AC000000UXX\\ShoppingCart .

    READ ENTITIES OF zr_AC000000UXX IN LOCAL MODE
       ENTITY ShoppingCart
         ALL FIELDS WITH CORRESPONDING #( keys )
       RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity) WHERE OverallStatus = zbp_r_AC000000UXX=>order_state-new.
      update_line-%tky    = entity-%tky.
      update_line-OverallStatus = zbp_r_AC000000UXX=>order_state-saved.
      APPEND update_line TO update.
    ENDLOOP.

    MODIFY ENTITIES OF zr_AC000000UXX IN LOCAL MODE
     ENTITY ShoppingCart
       UPDATE FIELDS ( OverallStatus )
         WITH update
    REPORTED DATA(update_reported).

    "Set the changing parameter
    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validateOrderedItem.

    "For your convinience there is a central class ZAX_AC_EXCEPTIONS that is beeing used here.

    READ ENTITIES OF zr_AC000000Uxx IN LOCAL MODE
       ENTITY ShoppingCart
         FIELDS (  OrderedItem )
         WITH CORRESPONDING #( keys )
       RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      APPEND VALUE #(  %tky               = entity-%tky
                       %state_area        = 'VALIDATE_ORDERED_ITEM' ) TO reported-shoppingcart.
      IF entity-OrderedItem IS INITIAL.
        APPEND VALUE #( %tky = entity-%tky ) TO failed-shoppingcart.

        APPEND VALUE #( %tky               = entity-%tky
                        %state_area        = 'VALIDATE_ORDERED_ITEM'
                        %msg               = NEW zcx_ac_exceptions(
                                                 textid   = zcx_ac_exceptions=>enter_order_item
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-ordereditem = if_abap_behv=>mk-on ) TO reported-shoppingcart.
      ENDIF.

      "For your convinience there are GLOBAL defined types available:
      DATA product_api TYPE REF TO zcl_AC_PRODUCT_API.
      DATA business_data TYPE zcl_AC_PRODUCT_API=>t_business_data_external.

      "... later on, you will be replacing them with your own types.
      "DATA product_api TYPE REF TO zcl_AC000000Uxx_PRODUCT_API.
      "DATA business_data TYPE zcl_AC000000Uxx_PRODUCT_API=>t_business_data_external.

      DATA filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs .
      DATA ranges_table TYPE if_rap_query_filter=>tt_range_option .

      product_api = NEW #(  ).

      ranges_table = VALUE #(
                              (  sign = 'I' option = 'EQ' low = entity-OrderedItem )
                            ).

      filter_conditions = VALUE #( ( name = 'PRODUCT'  range = ranges_table ) ).

      TRY.
          product_api->get_products(
            EXPORTING
              it_filter_cond    = filter_conditions
              top               =  50
              skip              =  0
            IMPORTING
              et_business_data  = business_data
            ) .

          IF business_data IS INITIAL.
            APPEND VALUE #( %tky               = entity-%tky
                            %state_area        = 'VALIDATE_ORDERED_ITEM'
                            %msg               = NEW zcx_ac_exceptions(
                                                     textid   = zcx_ac_exceptions=>product_unkown
                                                     severity = if_abap_behv_message=>severity-error )
                            %element-ordereditem = if_abap_behv=>mk-on ) TO reported-shoppingcart.
          ENDIF.

        CATCH cx_root INTO DATA(exception).
          ASSERT 1 = 2.
*          out->write( cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ) ).
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.

  METHOD validateOrderQuantity.

    "For your convinience there is a central class ZAX_AC_EXCEPTIONS that is beeing used here.

    READ ENTITIES OF zr_AC000000Uxx IN LOCAL MODE
       ENTITY ShoppingCart
         FIELDS (  OrderQuantity )
         WITH CORRESPONDING #( keys )
       RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      APPEND VALUE #(  %tky               = entity-%tky
                       %state_area        = 'VALIDATE_ORDER_QUANTITY' ) TO reported-shoppingcart.

      IF entity-OrderQuantity IS INITIAL.
        APPEND VALUE #( %tky = entity-%tky ) TO failed-shoppingcart.

        APPEND VALUE #( %tky               = entity-%tky
                        %state_area        = 'VALIDATE_ORDER_QUANTITY'
                         %msg              = NEW zcx_ac_exceptions(
                                                 textid   = zcx_ac_exceptions=>enter_order_quantity
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-requesteddeliverydate = if_abap_behv=>mk-on ) TO reported-shoppingcart.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  METHOD validateRequestedDeliveryDate.

    "For your convinience there is a central class ZAX_AC_EXCEPTIONS that is beeing used here.

    READ ENTITIES OF zr_AC000000Uxx IN LOCAL MODE
       ENTITY ShoppingCart
         FIELDS (  RequestedDeliveryDate )
         WITH CORRESPONDING #( keys )
       RESULT DATA(entities).

    LOOP AT entities INTO DATA(entity).
      APPEND VALUE #(  %tky               = entity-%tky
                       %state_area        = 'VALIDATE_DATES' ) TO reported-shoppingcart.

      APPEND VALUE #(  %tky               = entity-%tky
                       %state_area        = 'OUTDATED_DATES' ) TO reported-shoppingcart.

      IF entity-RequestedDeliveryDate IS INITIAL.
        APPEND VALUE #( %tky = entity-%tky ) TO failed-shoppingcart.

        APPEND VALUE #( %tky               = entity-%tky
                        %state_area        = 'VALIDATE_DATES'
                         %msg              = NEW zcx_ac_exceptions(
                                                 textid   = zcx_ac_exceptions=>enter_requested_delivery_date
                                                 severity = if_abap_behv_message=>severity-error )
                        %element-requesteddeliverydate = if_abap_behv=>mk-on ) TO reported-shoppingcart.

      ELSEIF entity-RequestedDeliveryDate < cl_abap_context_info=>get_system_date( ).
        APPEND VALUE #( %tky               = entity-%tky ) TO failed-shoppingcart.

        APPEND VALUE #( %tky               = entity-%tky
                        %state_area        = 'OUTDATED_DATES'
                         %msg              = NEW zcx_ac_exceptions(
                                                                textid     = zcx_ac_exceptions=>out_dated_req_delivery_date
                                                                severity   = if_abap_behv_message=>severity-error )
                        %element-requesteddeliverydate = if_abap_behv=>mk-on ) TO reported-shoppingcart.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zr_ac000000uxx DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zr_ac000000uxx IMPLEMENTATION.

  METHOD save_modified.
    DATA : ShoppingCarts       TYPE STANDARD TABLE OF zAC000000Uxx,
           ShoppingCart        TYPE                   zAC000000Uxx,
           events_to_be_raised TYPE TABLE FOR EVENT zr_AC000000Uxx~statusUpdated.

    IF create-shoppingcart IS NOT INITIAL.
      LOOP AT create-shoppingcart INTO DATA(create_shoppingcart).
        IF create_shoppingcart-%control-OverallStatus = if_abap_behv=>mk-on
          " AND create_shoppingcart-OverallStatus = zbp_r_AC000000Uxx=>order_state-in_process.
          AND create_shoppingcart-OverallStatus = zbp_r_AC000000Uxx=>order_state-saved.
          zcl_AC000000Uxx_start_bgpf=>run_via_bgpf_tx_uncontrolled( i_rap_bo_key = create_shoppingcart-OrderUuid ).
        ENDIF.
      ENDLOOP.
    ENDIF.

    "the salesorder and the status is updated via BGPF
    IF update-shoppingcart IS NOT INITIAL.
      LOOP AT update-shoppingcart INTO DATA(update_shoppingcart).
        IF update_shoppingcart-%control-SalesOrderStatus = if_abap_behv=>mk-on.
          CLEAR events_to_be_raised.
          APPEND INITIAL LINE TO events_to_be_raised.
          events_to_be_raised[ 1 ] = CORRESPONDING #( update_shoppingcart ).
          RAISE ENTITY EVENT zr_AC000000Uxx~statusUpdated FROM events_to_be_raised.
        ENDIF.

        IF update_shoppingcart-%control-OverallStatus = if_abap_behv=>mk-on
          "AND update_shoppingcart-OverallStatus = zbp_r_AC000000Uxx=>order_state-in_process.
          AND update_shoppingcart-OverallStatus = zbp_r_AC000000Uxx=>order_state-saved.
          zcl_AC000000Uxx_start_bgpf=>run_via_bgpf_tx_uncontrolled( i_rap_bo_key = update_shoppingcart-OrderUuid ).
        ENDIF.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.



ENDCLASS.
