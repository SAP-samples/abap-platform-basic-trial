CLASS zcx_ac_exceptions DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_t100_dyn_msg .
    INTERFACES if_t100_message .
    INTERFACES if_abap_behv_message .

    CONSTANTS:
      gc_msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',

      BEGIN OF product_unkown,
        msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'MV_ORDERED_ITEM',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF product_unkown,



      BEGIN OF enter_requested_delivery_date,
        msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_requested_delivery_date,

      BEGIN OF enter_order_quantity,
        msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_order_quantity,

      BEGIN OF enter_order_item,
        msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF enter_order_item,

      BEGIN OF out_dated_req_delivery_date,
        msgid TYPE symsgid VALUE 'ZCM_AC_MESSAGES',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF out_dated_req_delivery_date.



    METHODS constructor
      IMPORTING
        textid       LIKE if_t100_message=>t100key OPTIONAL
        attr1        TYPE string OPTIONAL
        attr2        TYPE string OPTIONAL
        attr3        TYPE string OPTIONAL
        attr4        TYPE string OPTIONAL
        previous     LIKE previous OPTIONAL
        ordered_item TYPE matnr40  OPTIONAL
        severity     TYPE if_abap_behv_message=>t_severity OPTIONAL
      .

  PROTECTED SECTION.
  PRIVATE SECTION.
    DATA:
      mv_attr1        TYPE string,
      mv_attr2        TYPE string,
      mv_attr3        TYPE string,
      mv_attr4        TYPE string,
      mv_ordered_item TYPE c LENGTH 8,
      mv_severity     TYPE if_abap_behv_message=>t_severity.

ENDCLASS.



CLASS ZCX_AC_EXCEPTIONS IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor(  previous = previous ) .

    me->mv_attr1                 = attr1.
    me->mv_attr2                 = attr2.
    me->mv_attr3                 = attr3.
    me->mv_attr4                 = attr4.
    me->mv_ordered_item            = ordered_item.

    if_abap_behv_message~m_severity = severity.

    CLEAR me->textid.
    IF textid IS INITIAL.
      if_t100_message~t100key = if_t100_message=>default_textid.
    ELSE.
      if_t100_message~t100key = textid.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
